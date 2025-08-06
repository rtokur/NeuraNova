//
//  CreateViewModel.swift
//  NeuraNova-Product-Tagger
//
//  Created by Rumeysa Tokur on 30.07.2025.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class CreateViewModel {
    var onLoadingStateChange: ((Bool) -> Void)?
    var onMetadataUpdate: ((ContentModel) -> Void)?
    var onError: ((String) -> Void)?
    var onSaveSuccess: (() -> Void)?
    var onDeleteSuccess: (() -> Void)?
    var contents: [ContentModel] = []
    var onContentsUpdate: (() -> Void)?
    
    private let db = Firestore.firestore()
    
    func fetchUserContents() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("kullanıcı yok")
            return
        }
        
        db.collection("users")
            .document(userId)
            .collection("content")
            .getDocuments { [weak self] snapshot, error in
                if let error = error {
                    print("Firestore Error: \(error.localizedDescription)")
                    return
                }
                
                self?.contents = snapshot?.documents.compactMap { doc in
                    try? doc.data(as: ContentModel.self)
                } ?? []
                
                self?.onContentsUpdate?()
            }
    }
    
    func generateMetadata(from image: UIImage) {
        guard let url = URL(string: "https://41f227f2dba3.ngrok-free.app/generate_metadata") else { return }
        
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
                let decodedAPI = try JSONDecoder().decode(APIContentModel.self, from: data)
                
                let converted = ContentModel(
                    title: decodedAPI.title,
                    description: decodedAPI.description,
                    tags: decodedAPI.tags,
                    imageUrl: nil
                )
                
                DispatchQueue.main.async {
                    self?.onMetadataUpdate?(converted)
                }
            } catch {
                DispatchQueue.main.async {
                    self?.onError?("Metadata format hatası: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    func saveMetadata(_ metadata: ContentModel, image: UIImage? = nil) {
        guard let userId = Auth.auth().currentUser?.uid else {
            onError?("Kullanıcı giriş yapmamış")
            return
        }
        
        guard let image = image,
              let imageData = image.jpegData(compressionQuality: 0.8) else {
            onError?("Fotoğraf bulunamadı")
            return
        }
        
        let storageRef = Storage.storage().reference()
            .child("users/\(userId)/images/\(UUID().uuidString).jpg")
        
        storageRef.putData(imageData, metadata: nil) { [weak self] metadataStorage, error in
            if let error = error {
                self?.onError?("Fotoğraf yüklenemedi: \(error.localizedDescription)")
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    self?.onError?("Fotoğraf URL alınamadı: \(error.localizedDescription)")
                    return
                }
                
                guard let downloadURL = url else {
                    self?.onError?("Geçersiz fotoğraf URL’si")
                    return
                }
                
                let data: [String: Any] = [
                    "title": metadata.title,
                    "description": metadata.description,
                    "tags": metadata.tags,
                    "imageUrl": downloadURL.absoluteString,
                    "createdAt": FieldValue.serverTimestamp()
                ]
                
                self?.db.collection("users").document(userId)
                    .collection("content")
                    .addDocument(data: data) { error in
                        if let error = error {
                            self?.onError?("Metadata kaydedilemedi: \(error.localizedDescription)")
                        } else {
                            let docRef = self?.db.collection("users").document(userId)
                                .collection("content").whereField("imageUrl", isEqualTo: downloadURL.absoluteString)
                            
                            docRef?.getDocuments { snapshot, _ in
                                if let docId = snapshot?.documents.first?.documentID {
                                    var updatedModel = metadata
                                    updatedModel.id = docId
                                    
                                    DispatchQueue.main.async {
                                        self?.onMetadataUpdate?(updatedModel)
                                        self?.onSaveSuccess?()
                                    }
                                } else {
                                    DispatchQueue.main.async {
                                        self?.onSaveSuccess?()
                                    }
                                }
                            }
                        }
                    }
            }
        }
    }
    
    
    func deleteContent(_ content: ContentModel) {
        guard let userId = Auth.auth().currentUser?.uid else {
            onError?("Kullanıcı giriş yapmamış")
            return
        }
        
        guard let contentId = content.id else {
            onError?("Silinecek içerik bulunamadı")
            return
        }
        
        db.collection("users").document(userId)
            .collection("content").document(contentId)
            .delete { [weak self] error in
                if let error = error {
                    self?.onError?("İçerik silinemedi: \(error.localizedDescription)")
                    return
                }
                
                if let imageUrl = URL(string: content.imageUrl ?? "") {
                    let storageRef = Storage.storage().reference(forURL: imageUrl.absoluteString)
                    storageRef.delete { _ in
                        self?.refreshAfterDelete(userId: userId)
                    }
                } else {
                    self?.refreshAfterDelete(userId: userId)
                }
            }
    }
    
    private func refreshAfterDelete(userId: String) {
        db.collection("users").document(userId)
            .collection("content")
            .getDocuments { [weak self] snapshot, error in
                if let error = error {
                    self?.onError?("Liste güncellenemedi: \(error.localizedDescription)")
                    return
                }
                
                self?.contents = snapshot?.documents.compactMap {
                    try? $0.data(as: ContentModel.self)
                } ?? []
                
                self?.onContentsUpdate?()
                self?.onDeleteSuccess?()
            }
    }
}
