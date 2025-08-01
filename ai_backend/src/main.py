from fastapi import FastAPI, UploadFile, File, HTTPException
from starlette.responses import JSONResponse
from fastapi.middleware.cors import CORSMiddleware
import os
import logging

from src.inference import generate_from_gemini
from src.image_utils import process_image

# Logging ayarı tetiklenmesini sağlayan kod
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = FastAPI(title="NeuraNova AI Backend Beta", version="1.0")

# CORS (UIKit bağlantısı için gerekli)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Gerekirse iOS cihaz IP’sini buraya ekleyebilirsin
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.post("/generate_metadata")
async def generate_metadata(file: UploadFile = File(...)):
    if not file.content_type.startswith("image/"):
        raise HTTPException(status_code=415, detail="Sadece görsel dosyaları kabul edilir.")
    
    
    temp_path = f"temp_{file.filename}"
    processed_path = f"processed_{file.filename}"
    
    try:
        #  Dosyayı geçici olarak kaydet
        with open(temp_path, "wb") as f:
            file_bytes = await file.read()
            f.write(file_bytes)
        logger.info(f"Görsel kaydedildi: {temp_path} ({len(file_bytes)} bytes)")

        #  Görseli optimize et
        optimized_image = process_image(temp_path, processed_path)
        logger.info(f"Görsel işlendi: {processed_path}")

        #  Gemini API ile metadata üret
        gemini_output = generate_from_gemini(optimized_image)
        logger.info(f"Gemini AI çıktı üretildi: {gemini_output}")

        #  Yanıtı JSON olarak döndür

        return JSONResponse(content=gemini_output)
    
    except Exception as e:
        logger.error(f"Hata oluştu: {e}")
        raise HTTPException(status_code=500, detail="İşlem sırasında bir hata oluştu.")
    
    finally:
        # Geçici dosyaları sil
        for path in [temp_path, processed_path]:
            if os.path.exists(path):
                os.remove(path)
                logger.info(f"Silindi: {path}")
        