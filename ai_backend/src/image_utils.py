from PIL import Image
import os

def process_image(input_path: str, output_path: str, max_size=(1024, 1024)) -> str:
    """
    Görseli Pillow ile açar, boyutlandırır ve optimize edilmiş versiyonunu kaydeder.
    max_size: (width, height) formatında maksimum boyut.
    """
    with Image.open(input_path) as img:
        # RGBA / P modlarını RGB'ye çevir
        if img.mode in ("RGBA", "P"):
            img = img.convert("RGB")

        # Oranı koruyarak yeniden boyutlandır
        img.thumbnail(max_size)

        # Optimize edilmiş görseli kaydet
        img.save(output_path, optimize=True, quality=85)

    return output_path
