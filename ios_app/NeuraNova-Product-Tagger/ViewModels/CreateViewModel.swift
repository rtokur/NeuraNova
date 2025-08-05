//
//  CreateViewModel.swift
//  NeuraNova-Product-Tagger
//
//  Created by Rumeysa Tokur on 30.07.2025.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class CreateViewModel {
    private let db = Firestore.firestore()
    
    var onLoadingStateChange: ((Bool) -> Void)?
    var onMetadataUpdate: ((ContentModel) -> Void)?
    var onError: ((String) -> Void)?
    var onSaveSuccess: (() -> Void)?
    
    func generateMetadata(from image: UIImage) {
        guard let url = URL(string: "https://5df5061d2be5.ngrok-free.app/generate_metadata") else { return }
        
        onLoadingStateChange?(true)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.onLoadingStateChange?(false)
            }
            
            if let error = error {
                self?.onError?(error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decoded = try JSONDecoder().decode(ContentModel.self, from: data)
                DispatchQueue.main.async {
                    self?.onMetadataUpdate?(decoded)
                }
            } catch {
                DispatchQueue.main.async {
                    self?.onError?(error.localizedDescription)
                }
            }
        }.resume()
    }
    
    func saveMetadata(_ metadata: ContentModel) {
        guard let userId = Auth.auth().currentUser?.uid else {
            onError?("Kullanıcı giriş yapmamış")
            return
        }
        
        let data: [String: Any] = [
            "title": metadata.title,
            "description": metadata.description,
            "tags": metadata.tags,
            "createdAt": FieldValue.serverTimestamp()
        ]
        
        db.collection("users").document(userId).collection("metadata").addDocument(data: data) { [weak self] error in
            if let error = error {
                self?.onError?(error.localizedDescription)
            } else {
                self?.onSaveSuccess?()
            }
        }
    }
}
