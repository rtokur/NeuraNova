# NeuraNova AI Backend - API Kullanım Dökümanı

- Bu döküman, **NeuraNova AI Backend** üzerinde yer alan `generate_metadata` endpoint’inin nasıl kullanılacağını açıklamaktadır.

---

## Base URL

```
http://127.0.0.1:8081
```

---

## Endpointler

### 1️ **POST /generate_metadata**

- Görsel dosyasını yükler, ürün başlığı, açıklaması ve etiketleri üretir.

* **URL**

```
POST /generate_metadata
```

- **İstek Parametreleri**
  \| Parametre | Tipi | Zorunlu | Açıklama |
  \|-----------|-------------|---------|----------|
  \| file | `UploadFile`| | JPG, JPEG, PNG veya WEBP formatında ürün görseli |

- **Desteklenen Dosya Formatları**

```
.jpg, .jpeg, .png, .webp
```

---

## **İstek Örneği (cURL)**

```bash
curl -X POST "http://127.0.0.1:8081/generate_metadata" \
  -H "accept: application/json" \
  -F "file=@test_image.jpg"
```

---

## **Başarılı Yanıt Örneği (200)**

```json
{
  "title": "Kiko Milano Pembe Dudak Parlatıcısı",
  "description": "Kiko Milano'nun bu pembe dudak parlatıcısı, dudaklara doğal bir parlaklık ve nemlendirme sağlar. Gün boyu kalıcı yapısıyla dudaklarınızı her zaman canlı tutar.",
  "tags": [
    "Kiko Milano",
    "dudak parlatıcısı",
    "pembe parlatıcı",
    "makyaj",
    "dudak bakımı"
  ]
}
```

---

## **Hata Yanıtları**

- **415 - Geçersiz Dosya Formatı**

```json
{
  "detail": "Sadece görsel dosyaları kabul edilir."
}
```

- **422 - Boş Dosya**

```json
{
  "detail": "Boş görsel dosyası gönderildi."
}
```

- **422 - Dosya Alanı Eksik**

```json
{
  "detail": "Dosya seçilmedi veya gönderilmedi."
}
```

- **500 - Sunucu Hatası**

```json
{
  "detail": "İşlem sırasında bir hata oluştu."
}
```

---

## **Loglama**

- **Başarılı istekler** → `logs/app.log`
- **Hatalar** → `logs/errors.log`

---

## **Outputs**

- Tüm AI çıktıları `outputs/` klasöründe JSON formatında kaydedilir.
- Dosya isim formatı:

```
output_{temizlenmiş_title}_{YYYYMMDD_HHMMSS}.json
```

---

## **Önemli Notlar**

- Sunucu kapatıldığında otomatik olarak `outputs/` klasöründeki JSON dosyaları `scripts/check_outputs.py` ile kalite kontrol edilir.
- Her hata `errors.log` içinde kaydedilir.
