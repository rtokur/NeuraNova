from fastapi.testclient import TestClient
from src.main import app

client = TestClient(app)

def test_generate_metadata_with_image():
    with open("test/sample_image.jpg", "rb") as img:
        response = client.post("/generate_metadata", files={"file": ("sample_image.jpg", img, "image/jpeg")})
    assert response.status_code == 200
    assert "title" in response.json()

def test_generate_metadata_with_invalid_file():
    with open("test/sample_text.txt", "rb") as txt:
        response = client.post("/generate_metadata", files={"file": ("sample_text.txt", txt, "text/plain")})
    assert response.status_code == 415
