# 🛍️ NeuraNova – AI Destekli Ürün Açıklama ve Etiketleme Uygulaması

*NeuraNova*, kullanıcıların bir ürün fotoğrafı yüklemesiyle otomatik olarak başlık, açıklama ve etiketler üreten yapay zeka tabanlı bir mobil uygulamadır.  
iOS frontend ve Python backend bileşenlerinin birleştiği bu sistem; hızlı, akıllı ve SEO-dostu içerik üretimi sağlar.

---

## 🚀 Özellikler

•⁠  ⁠📸 *Görselden otomatik analiz* (kamera veya galeriden yükleme)
•⁠  ⁠🧠 *AI ile başlık, açıklama ve etiket üretimi* (Gemini Pro Vision API)
•⁠  ⁠⚡ *Gerçek zamanlı ve hızlı yanıt*
•⁠  ⁠📱 *Modern ve kullanıcı dostu iOS arayüzü*
•⁠  ⁠🔄 *Backend & frontend entegrasyonu (FastAPI + Swift)*

---

## 📲 Kullanıcı Akışı

1.⁠ ⁠Kullanıcı, mobil uygulamadan bir ürün fotoğrafı seçer veya çeker.
2.⁠ ⁠Görsel, FastAPI ile çalışan sunucuya gönderilir.
3.⁠ ⁠Backend, Gemini API’yi kullanarak görseli işler ve içerik üretir:
   - Ürün başlığı
   - Açıklayıcı metin
   - İlgili etiketler (SEO uyumlu)
4.⁠ ⁠Üretilen içerikler anında mobil arayüzde görüntülenir.

---

## 🧠 Kullanılan Teknolojiler

| Katman | Teknolojiler |
|--------|--------------|
| 🎨 *Frontend* | Swift, UIKit, SnapKit, MVVM, Firebase |
| 🧠 *AI Backend* | Python, FastAPI, Gemini Pro Vision API |
| 🔗 *Entegrasyon* | Ngrok ile tünellenmiş API, JSON response |
| 🔐 *Güvenlik* | .env dosyası ile gizli anahtarlar korunur |
| 🧪 *Test* | Postman, TestFlight, API Logger, script testleri |

---

## 🧑‍💻 Proje Ekibi

| İsim | Rol | Açıklama |
|------|-----|----------|
| Mehmetcan | 💻 AI Engineer & Backend Developer | FastAPI sunucusu, Gemini entegrasyonu, veri işleme |
| Rümeysa Tokur | 📱 iOS Developer | Swift uygulama geliştirme, arayüz ve API bağlantısı |

---

## 📦 Klasör Yapısı (Kısaltılmış)

\⁠ \ ⁠\`
NeuraNova/
├── ios_app/                     # iOS Swift projesi
│   └── NeuraNova-Product-Tagger/
├── ai_backend/                 # Python FastAPI backend
│   ├── src/                    # AI logic + API endpoints
│   ├── scripts/                # Test ve yardımcı scriptler
│   ├── prompts/                # Gemini prompt şablonları
│   ├── docs/                   # API kullanım dökümanları
│   └── .env.example            # Ortam değişkeni örneği
\⁠ \ ⁠\`

---

## ⚙️ Nasıl Çalıştırılır? (Backend)

1.⁠ ⁠Ortamı oluştur:
   \⁠ \ ⁠\`bash
   python -m venv venv
   source venv/bin/activate  # veya Windows için: venv\Scripts\activate
   pip install -r requirements.txt
   \⁠ \ ⁠\`

2.⁠ ⁠.env dosyasını oluştur ve Gemini API anahtarını ekle:
   \⁠ \ ⁠\`
   GEMINI_API_KEY=your_gemini_api_key_here
   \⁠ \ ⁠\`

3.⁠ ⁠Sunucuyu başlat:
   \⁠ \ ⁠\`bash
   uvicorn src.main:app --reload --port 8080
   \⁠ \ ⁠\`

4.⁠ ⁠Ngrok ile dış dünyaya aç:
   \⁠ \ ⁠\`bash
   ngrok http 8080
   \⁠ \ ⁠\`

5.⁠ ⁠Postman veya Swift uygulamasıyla /generate_metadata endpoint’ine görsel gönder.

---

## 🔗 Örnek API Çağrısı

### Endpoint
\⁠ \ ⁠\`
POST /generate_metadata
\⁠ \ ⁠\`

### Form Data
| Key | Tip | Açıklama |
|-----|-----|----------|
| file | Görsel | .jpg veya .png formatında ürün fotoğrafı |

### Response
\⁠ \ ⁠\`json
{
  "title": "Şık Desenli Kadın V Yaka Bluz",
  "description": "Bu zarif V yaka bluz, şık deseniyle her kombine uyum sağlar.",
  "tags": ["kadın bluz", "V yaka", "desenli", "şık", "günlük"]
}
\⁠ \ ⁠\`

---

## 💡 Neden NeuraNova?

	⁠“Yapay zekayı, içeriğin kalbine yerleştirdik.”

•⁠  ⁠Zaman kazandırır  
•⁠  ⁠Kaliteli içerik üretir  
•⁠  ⁠SEO uyumlu  
•⁠  ⁠Tamamen otomatik  
•⁠  ⁠Modern UI + güçlü AI kombinasyonu

---

## 🏁 Proje Durumu

✅ MVP tamamlandı  
🚀 iOS arayüz ile entegrasyon tamamlandı  
🧪 Test süreci başladı  
📦 Yayına hazır (lokal kullanım)  

---

## 📃 Lisans
Bu proje yalnızca eğitim ve demo amaçlıdır. Her hakkı saklıdır.
