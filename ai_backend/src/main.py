from fastapi import FastAPI, UploadFile, File, HTTPException
from starlette.responses import JSONResponse
import os

from src.inference import generate_from_gemini
from src.image_utils import process_image

app = FastAPI()

@app.post("/generate_metadata")
async def generate_metadata(file: UploadFile = File(...)):
    if not file.content_type.startswith("image/"):
        raise HTTPException(status_code=415, detail="Sadece görsel dosyaları kabul edilir.")
    
    temp_path = f"temp_{file.filename}"
    processed_path = f"processed_{file.filename}"
    
    try:
        # Dosyayı kaydet
        with open(temp_path, "wb") as f:
            f.write(await file.read())

        # Görseli optimize et
        optimized_image = process_image(temp_path, processed_path)

        # Gemini API'den metadata al
        gemini_output = generate_from_gemini(optimized_image)
        
        return JSONResponse(content=gemini_output)
    
    finally:
        # Geçici dosyaları sil
        for path in [temp_path, processed_path]:
            if os.path.exists(path):
                os.remove(path)
