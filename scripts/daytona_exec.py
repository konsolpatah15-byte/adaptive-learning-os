#!/usr/bin/env python3
"""Run a shell command inside the Daytona sandbox via Toolbox API and print stdout/stderr."""
import os, sys, json, time, urllib.request

API_KEY = os.environ.get("DAYTONA_API_KEY", "")
SANDBOX_ID = os.environ.get("DAYTONA_SANDBOX_ID", "sbx_AsSia1qGjNe91FG2JtWbEx-us-east-ash-1")
BASE = os.environ.get("DAYTONA_TOOLBOX", "https://proxy.ash-1.us-east.daytona.app/toolbox")
URL = f"{BASE}/{SANDBOX_ID}"

def req(path, method="GET", body=None, attempts=5):
    data = json.dumps(body).encode() if body is not None else None
    r = urllib.request.Request(URL + path, data=data, method=method,
        headers={"Authorization": f"Bearer {API_KEY}", "Content-Type": "application/json"})
    last = None
    for i in range(attempts):
        try:
            with urllib.request.urlopen(r, timeout=120) as resp:
                raw = resp.read().decode()
            return json.loads(raw) if raw else {}
        except urllib.error.HTTPError as e:
            last = e
            if e.code in (429, 500, 502, 503, 504) and i < attempts - 1:
                time.sleep(2 ** i)
                continue
            raise
    raise last

def run(cmd, timeout=300):
    p = req("/processes", "POST", {"shellCommand": cmd})
    pid = p["id"]
    deadline = time.time() + timeout
    cursor = None
    out, err = [], []
    while time.time() < deadline:
        path = f"/processes/{pid}/logs"
        if cursor:
            path += f"?cursor={cursor}"
        logs = req(path)
        for f in logs.get("frames", []):
            (err if f.get("channel") == "stderr" else out).append(f.get("data", ""))
        cursor = logs.get("nextCursor") or cursor
        if logs.get("eof") and req(f"/processes/{pid}").get("state") != "running":
            break
        time.sleep(1)
    return {"exit": req(f"/processes/{pid}").get("exitCode"), "stdout": "".join(out), "stderr": "".join(err)}

if __name__ == "__main__":
    cmd = sys.argv[1] if len(sys.argv) > 1 else sys.stdin.read()
    r = run(cmd)
    print(r["stdout"])
    if r["stderr"]:
        print("[STDERR]", r["stderr"], file=sys.stderr)
    sys.exit(0 if r["exit"] in (0, None) else 1)
