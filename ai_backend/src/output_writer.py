import os
import json
import re
from datetime import datetime
from src.logging_config import logger

def save_gemini_output(gemini_output: dict, directory: str = "outputs") -> str:
    """
    Gemini çıktısını belirtilen klasöre kaydeder.
    Başlığa dayalı dosya ismi üretir ve log kaydı düşer.
    
    Args:
        gemini_output (dict): Gemini modelinden dönen çıktı
        directory (str): Kayıt yapılacak klasör (varsayılan 'outputs')
    
    Returns:
        str: Tam dosya yolu
    """
    try:
        os.makedirs(directory, exist_ok=True)

        # Başlık üzerinden dosya adı oluştur
        raw_title = gemini_output.get("title", "output").lower().strip()

        # Güvenli dosya adı için temizleme
        title_clean = re.sub(r"[^\w\s-]", "", raw_title)  # Sadece harf, sayı, boşluk, tire
        title_clean = (
            title_clean.replace(" ", "_")
                        .replace("ı", "i")
                        .replace("ğ", "g")
                        .replace("ü", "u")
                        .replace("ş", "s")
                        .replace("ö", "o")
                        .replace("ç", "c")
        )[:50]  # Çok uzun başlıkları kırp

        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        filename = f"output_{title_clean}_{timestamp}.json"
        output_path = os.path.join(directory, filename)

        # JSON dosyası olarak kaydet
        with open(output_path, "w", encoding="utf-8") as f:
            json.dump(gemini_output, f, ensure_ascii=False, indent=2)

        logger.info(f"Gemini output kaydedildi: {output_path}")
        return output_path

    except Exception as e:
        logger.error(f"Output kaydı sırasında hata oluştu: {e}", exc_info=True)
        raise
