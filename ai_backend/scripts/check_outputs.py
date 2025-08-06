import os
import json
from src.logging_config import logger  # Loglara yazmak için import ettik

OUTPUTS_DIR = "outputs"

def check_outputs():
    errors = []
    
    if not os.path.exists(OUTPUTS_DIR):
        logger.error(f"'{OUTPUTS_DIR}' klasörü bulunamadı!")
        return False
    
    files = [f for f in os.listdir(OUTPUTS_DIR) if f.endswith(".json")]
    if not files:
        logger.warning(f"'{OUTPUTS_DIR}' klasöründe JSON dosyası bulunamadı.")
        return False
    
    logger.info(f"{len(files)} dosya kontrol ediliyor...")
    
    for file_name in files:
        file_path = os.path.join(OUTPUTS_DIR, file_name)
        try:
            with open(file_path, "r", encoding="utf-8") as f:
                data = json.load(f)
            
            for key in ["title", "description", "tags"]:
                if key not in data:
                    errors.append(f"{file_name} → Eksik alan: {key}")
            
            if "tags" in data:
                if not isinstance(data["tags"], list):
                    errors.append(f"{file_name} → 'tags' bir liste değil")
                elif len(data["tags"]) != 5:
                    errors.append(f"{file_name} → 'tags' 5 adet değil ({len(data['tags'])})")
        
        except json.JSONDecodeError:
            errors.append(f"{file_name} → Geçersiz JSON formatı")
        except Exception as e:
            errors.append(f"{file_name} → Hata: {e}")
    
    if errors:
        logger.error("Outputs kontrolünde hatalar bulundu:")
        for err in errors:
            logger.error(f" - {err}")
        return False
    else:
        logger.info("Tüm JSON dosyaları geçerli!")
        return True

if __name__ == "__main__":
    check_outputs()
