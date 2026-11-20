"""Auth: bcrypt password hashing + JWT bearer tokens + in-memory rate limiter."""
from __future__ import annotations
import time
from collections import defaultdict, deque
from datetime import datetime, timedelta, timezone

import bcrypt
import jwt
from fastapi import Depends, HTTPException, Request
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer

from .config import secret_key, system
from .db import get_db

_bearer = HTTPBearer(auto_error=False)
ALGO = "HS256"


def hash_password(pw: str) -> str:
    return bcrypt.hashpw(pw.encode(), bcrypt.gensalt(rounds=10)).decode()


def verify_password(pw: str, hashed: str) -> bool:
    try:
        return bcrypt.checkpw(pw.encode(), hashed.encode())
    except ValueError:
        return False


def make_token(user_id: int, username: str) -> str:
    ttl = system()["auth"]["token_ttl_hours"]
    now = datetime.now(timezone.utc)
    return jwt.encode(
        {"sub": str(user_id), "usr": username,
         "iat": now, "exp": now + timedelta(hours=ttl)},
        secret_key(), algorithm=ALGO,
    )


def current_user(creds: HTTPAuthorizationCredentials | None = Depends(_bearer)) -> dict:
    if creds is None:
        raise HTTPException(401, "Not authenticated")
    try:
        payload = jwt.decode(creds.credentials, secret_key(), algorithms=[ALGO])
    except jwt.PyJWTError:
        raise HTTPException(401, "Invalid or expired token")
    with get_db() as db:
        row = db.execute(
            "SELECT id, username, display_name, role FROM users WHERE id=?",
            (int(payload["sub"]),),
        ).fetchone()
    if row is None:
        raise HTTPException(401, "User no longer exists")
    return dict(row)


class RateLimiter:
    """Sliding-window per-IP limiter. Bounded memory: one deque per active IP,
    pruned lazily; entries older than the window are dropped on access."""

    def __init__(self, per_minute: int):
        self.limit = per_minute
        self.hits: dict[str, deque] = defaultdict(deque)
        self._last_prune = time.monotonic()

    def check(self, key: str) -> bool:
        now = time.monotonic()
        if now - self._last_prune > 300:          # prune idle IPs every 5 min
            self.hits = defaultdict(deque, {k: v for k, v in self.hits.items() if v and now - v[-1] < 60})
            self._last_prune = now
        q = self.hits[key]
        while q and now - q[0] > 60:
            q.popleft()
        if len(q) >= self.limit:
            return False
        q.append(now)
        return True


limiter = RateLimiter(system()["auth"]["rate_limit_per_minute"])


async def rate_limit(request: Request):
    ip = request.client.host if request.client else "unknown"
    if not limiter.check(ip):
        raise HTTPException(429, "Rate limit exceeded — slow down")