import os
import base64
import json
import re
from dotenv import load_dotenv
import google.generativeai as genai

# .env dosyasını yükle
load_dotenv()

# API key ve model adı
api_key = os.getenv("GEMINI_API_KEY")
model_name = os.getenv("GEMINI_MODEL", "gemini-2.0-flash")
prompt_path = os.getenv("PROMPT_FILE", "prompts/prompt_caption_final_blended.txt")

if not api_key:
    raise ValueError("GEMINI_API_KEY .env dosyasında bulunamadı!")

# Gemini API konfigürasyonu
genai.configure(api_key=api_key)

def generate_from_gemini(image_path: str) -> dict:
    """
    Görseli Gemini API'ye gönderir, başlık, açıklama ve etiketleri döner.
    """
    try:
        # Prompt dosyasını oku
        with open(prompt_path, "r", encoding="utf-8") as pf:
            prompt = pf.read()

        # Görseli oku
        with open(image_path, "rb") as f:
            img_data = f.read()

        # Model çağrısı (görseli ayrı parametre ile veriyoruz)
        model = genai.GenerativeModel(model_name)
        response = model.generate_content(
            contents=[
                {"role": "user", "parts": [
                    {"text": prompt},
                    {"inline_data": {"mime_type": "image/png", "data": img_data}}
                ]}
            ]
        )

        raw_text = response.text.strip()

        # Gemini yanıtındaki gereksiz ```json``` bloklarını temizle
        clean_text = re.sub(r"```json|```", "", raw_text).strip()

        # JSON parse
        try:
            result_json = json.loads(clean_text)
        except json.JSONDecodeError:
            result_json = {"raw_output": clean_text}

        return result_json

    except Exception as e:
        return {"error": str(e)}
