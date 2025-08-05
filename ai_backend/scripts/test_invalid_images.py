import requests
import os

API_URL = "http://127.0.0.1:8081/generate_metadata"

def test_no_file():
    print("\n🧪 Test 1: Dosya seçilmedi")
    response = requests.post(API_URL, files={})
    print(f"Status: {response.status_code}")
    try:
        print(f"Response: {response.json()}")
    except Exception:
        print("Response (raw):", response.text)


def test_invalid_extension():
    print("\n🧪 Test 2: Geçersiz uzantı (.txt)")
    with open("scripts/test.txt", "w") as f:
        f.write("Bu bir test dosyasıdır.")
    with open("scripts/test.txt", "rb") as f:
        response = requests.post(API_URL, files={"file": ("test.txt", f, "text/plain")})
    print(f"Status: {response.status_code}")
    print(f"Response: {response.json()}")
    os.remove("scripts/test.txt")

def test_empty_image():
    print("\n🧪 Test 3: Boş görsel (.jpg)")
    with open("scripts/empty.jpg", "wb") as f:
        pass
    with open("scripts/empty.jpg", "rb") as f:
        response = requests.post(API_URL, files={"file": ("empty.jpg", f, "image/jpeg")})
    print(f"Status: {response.status_code}")
    print(f"Response: {response.json()}")
    os.remove("scripts/empty.jpg")

if __name__ == "__main__":
    test_no_file()
    test_invalid_extension()
    test_empty_image()
