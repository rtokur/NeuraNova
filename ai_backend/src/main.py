from fastapi import FastAPI, UploadFile, File, HTTPException
from fastapi.responses import JSONResponse
from fastapi.middleware.cors import CORSMiddleware
import os

# 🔹 Loglama konfigürasyonu
from src.logging_config import logger, setup_exception_handlers, setup_request_logger

from src.inference import generate_from_gemini
from src.image_utils import process_image
from src.output_writer import save_gemini_output

from scripts.check_outputs import check_outputs



app = FastAPI(title="NeuraNova AI Backend Beta", version="1.0")

# Exception handler’ları aktif et
setup_exception_handlers(app)
setup_request_logger(app)

# CORS (UIKit bağlantısı için gerekli)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Gerekirse iOS cihaz IP’sini buraya ekleyebilirsin
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.on_event("shutdown")
async def shutdown_event():
    logger.info("Server kapanıyor... Outputs klasörü kontrol ediliyor.")
    check_outputs()


@app.post("/generate_metadata")
async def generate_metadata(file: UploadFile = File(...)):
    # 🔒 1. MIME türü kontrolü
    if not file.content_type.startswith("image/"):
        raise HTTPException(status_code=415, detail="Sadece görsel dosyaları kabul edilir.")

    # 🔒 2. Dosya uzantısı kontrolü
    valid_extensions = [".jpg", ".jpeg", ".png", ".webp"]
    if not any(file.filename.lower().endswith(ext) for ext in valid_extensions):
        raise HTTPException(status_code=400, detail="Geçersiz dosya uzantısı. Sadece JPG, PNG ve WEBP dosyaları desteklenmektedir.")
    
    temp_path = f"temp_{file.filename}"
    processed_path = f"processed_{file.filename}"

    try:
        # 3. Dosyayı geçici olarak kaydet
        file_bytes = await file.read()
        if len(file_bytes) == 0:
            raise HTTPException(status_code=422, detail="Boş görsel dosyası gönderildi.")
        
        with open(temp_path, "wb") as f:
            f.write(file_bytes)
        logger.info(f"Görsel kaydedildi: {temp_path} ({len(file_bytes)} bytes)")

        # 4. Görseli optimize et
        optimized_image = process_image(temp_path, processed_path)
        logger.info(f"Görsel işlendi: {processed_path}")

        # 5. Gemini API ile metadata üret
        gemini_output = generate_from_gemini(optimized_image)
        logger.info(f"Gemini AI çıktı üretildi: {gemini_output}")

        # 6. Outputs klasörüne JSON olarak kaydet
        output_path = save_gemini_output(gemini_output)

        # 7. Yanıtı döndür
        return JSONResponse(content=gemini_output)

    except HTTPException as http_exc:
        # raise edilen HTTPException'ları yeniden fırlat
        raise http_exc
    except Exception as e:
        logger.error(f"Hata oluştu: {e}", exc_info=True)
        raise HTTPException(status_code=500, detail="İşlem sırasında bir hata oluştu.")
    finally:
        # 8. Geçici dosyaları temizle
        for path in [temp_path, processed_path]:
            if os.path.exists(path):
                os.remove(path)
                logger.info(f"Silindi: {path}")