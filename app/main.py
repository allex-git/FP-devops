from fastapi import FastAPI
import socket
from datetime import datetime, timezone

app = FastAPI()

START_TIME = datetime.now(timezone.utc)


def get_host_info():
    hostname = socket.gethostname()
    try:
        ip = socket.gethostbyname(hostname)
    except Exception:
        ip = "unknown"
    return hostname, ip

@app.get("/")
def root():
    hostname, ip = get_host_info()

    now = datetime.now(timezone.utc)
    uptime_seconds = int((now - START_TIME).total_seconds())

    return {
        "status": "ok",
        "hostname": hostname,
        "ip": ip,
        "author": "Allex_DevOps",
        "datetime": now.isoformat(),
        "started_at": START_TIME.isoformat()
        #"uptime_seconds": uptime_seconds
    }


@app.get("/healthz")
def health():
    return {
        "status": "healthy"
    }