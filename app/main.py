from fastapi import FastAPI
from fastapi.responses import HTMLResponse
from fastapi.staticfiles import StaticFiles

import socket
import os
from datetime import datetime, timezone

app = FastAPI()

app.mount("/web", StaticFiles(directory="webpage"), name="web")

START_TIME = datetime.now(timezone.utc)

POD_IP = os.getenv("POD_IP", "unknown")
POD_NAME = os.getenv("POD_NAME", "unknown")


def get_host_info():
    hostname = socket.gethostname()
    try:
        ip = socket.gethostbyname(hostname)
    except Exception:
        ip = "unknown"
    return hostname, ip

@app.get("/", response_class=HTMLResponse)
def root():
    with open("webpage/index.html", encoding="utf-8") as f:
        return f.read()

@app.get("/api")
def api():
    hostname, ip = get_host_info()
    now = datetime.now(timezone.utc)

    return {
        "status": "ok",
        "hostname": hostname,
        "ip": ip,
        "pod_ip": POD_IP,
        "pod_name": POD_NAME,
        "devops": "Allex DevOps",
        #"datetime": now.isoformat(),
        "uptime_seconds": int((now - START_TIME).total_seconds())
    }

@app.get("/healthz")
def health():
    return {"status": "healthy"}
#