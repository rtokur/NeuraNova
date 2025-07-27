from fastapi import FastAPI, UploadFile, File, HTTPException
from starlette.responses import JSONResponse

app = FastAPI()

@app.post("/generate_metadata")
async def generate_metadata(file: UploadFile = File(...)):
    if not file.content_type.startswith("image/"):
        raise HTTPException(status_code=415, detail="Sadece görsel dosyaları kabul edilir.")

    return JSONResponse({
        "title": "Test başlığı",
        "description": "Bu bir test açıklamasıdır.",
        "tags": ["örnek", "test", "demo"]
    })
