#!/usr/bin/env python3
"""
Whisper-API-Server für macOS (MLX, Apple Silicon).

Installation:
    pip install mlx-whisper fastapi uvicorn python-multipart

Starten (auf dem Mac):
    python scripts/whisper-server.py

Der Server läuft auf Port 8765 und ist vom DevContainer über
http://192.168.64.1:8765 erreichbar.
"""
import os
import shutil
import tempfile

import mlx_whisper
import uvicorn
from fastapi import FastAPI, File, UploadFile
from fastapi.responses import JSONResponse

MODEL = os.environ.get("WHISPER_MODEL", "mlx-community/whisper-large-v3-mlx")
PORT = int(os.environ.get("WHISPER_PORT", "8765"))

app = FastAPI(title="Whisper MLX Server")


@app.post("/v1/audio/transcriptions")
async def transcribe(file: UploadFile = File(...)):
    suffix = os.path.splitext(file.filename)[1] or ".mp3"
    with tempfile.NamedTemporaryFile(suffix=suffix, delete=False) as tmp:
        shutil.copyfileobj(file.file, tmp)
        path = tmp.name
    try:
        result = mlx_whisper.transcribe(path, path_or_hf_repo=MODEL)
    finally:
        os.unlink(path)
    return JSONResponse({"text": result["text"]})


@app.get("/health")
def health():
    return {"status": "ok", "model": MODEL}


if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=PORT)
