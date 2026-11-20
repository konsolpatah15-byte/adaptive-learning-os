"""Auth routes: login / logout / me. Bootstrap user created at startup."""
from fastapi import APIRouter, Depends, HTTPException

from ..core.db import get_db
from ..core.security import (current_user, hash_password, make_token,
                             verify_password, rate_limit)
from ..schemas.api import LoginIn

router = APIRouter(prefix="/api/auth", tags=["auth"])


@router.post("/login", dependencies=[Depends(rate_limit)])
def login(body: LoginIn):
    with get_db() as db:
        row = db.execute("SELECT * FROM users WHERE username=?", (body.username,)).fetchone()
    if row is None or not verify_password(body.password, row["password_hash"]):
        raise HTTPException(401, "Username atau password salah")
    return {"access_token": make_token(row["id"], row["username"]),
            "token_type": "bearer",
            "user": {"id": row["id"], "username": row["username"],
                     "display_name": row["display_name"], "role": row["role"]}}


@router.post("/logout")
def logout(user: dict = Depends(current_user)):
    # Stateless JWT: client discards token. Endpoint exists for API symmetry
    # and audit logging.
    from ..core.db import log_event
    log_event("auth", "logout", f"user={user['username']}")
    return {"ok": True}


@router.get("/me")
def me(user: dict = Depends(current_user)):
    return user