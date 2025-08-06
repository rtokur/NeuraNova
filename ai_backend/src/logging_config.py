import logging
from logging.handlers import RotatingFileHandler
import os
import time

from fastapi.responses import JSONResponse
from fastapi.exceptions import RequestValidationError
from starlette.exceptions import HTTPException as StarletteHTTPException
from fastapi import Request


# Log klasörü
LOG_DIR = "logs"
os.makedirs(LOG_DIR, exist_ok=True)

# Log dosyaları
APP_LOG_FILE = os.path.join(LOG_DIR, "app.log")
ERROR_LOG_FILE = os.path.join(LOG_DIR, "errors.log")

# Formatter (timestamp + level + message)
formatter = logging.Formatter("%(asctime)s - %(levelname)s - %(message)s")

# 🔹 INFO loglarının ERROR içermemesi için filtre
class MaxInfoFilter(logging.Filter):
    def filter(self, record):
        return record.levelno < logging.ERROR

# INFO / DEBUG log handler
app_handler = RotatingFileHandler(APP_LOG_FILE, maxBytes=5_000_000, backupCount=3)
app_handler.setLevel(logging.INFO)
app_handler.setFormatter(formatter)
app_handler.addFilter(MaxInfoFilter())  # ERROR seviyelerini filtrele


# ERROR log handler
error_handler = RotatingFileHandler(ERROR_LOG_FILE, maxBytes=2_000_000, backupCount=2)
error_handler.setLevel(logging.ERROR)
error_handler.setFormatter(formatter)


# Root logger
logging.basicConfig(
    level=logging.INFO,
    handlers=[app_handler, error_handler, logging.StreamHandler()]
)

logger = logging.getLogger(__name__)

# =====================================================
def setup_exception_handlers(app):
    @app.exception_handler(StarletteHTTPException)
    async def http_exception_handler(request: Request, exc: StarletteHTTPException):
        logger.error(f"HTTPException: {exc.detail} | Status: {exc.status_code} | Path: {request.url}")
        return JSONResponse(
            status_code=exc.status_code,
            content={"detail": exc.detail}
        )

    @app.exception_handler(RequestValidationError)
    async def validation_exception_handler(request: Request, exc: RequestValidationError):
        logger.error(f"Validation Error: {exc.errors()} | Path: {request.url}")
        return JSONResponse(
            status_code=422,
            content={"detail": exc.errors()}
        )

# Request Logger (Response Time Dahil)
# =====================================================
def setup_request_logger(app):
    @app.middleware("http")
    async def log_requests(request: Request, call_next):
        start_time = time.time()
        response = await call_next(request)
        process_time = (time.time() - start_time) * 1000
        
        log_message = f"Request: {request.method} {request.url.path} | Status: {response.status_code} | Time: {process_time:.2f} ms"
        
        if response.status_code >= 400:
            logger.error(log_message)  # Hatalar sadece errors.log’a
        else:
            logger.info(log_message)   # Başarılılar sadece app.log’a
        
        return response