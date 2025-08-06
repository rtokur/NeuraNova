//
//  HomeViewModel.swift
//  NeuraNova-Product-Tagger
//
//  Created by Rumeysa Tokur on 31.07.2025.
//

import Foundation
import FirebaseFirestore

final class HomeViewModel {
    
    var feedContents: [(userName: String, content: ContentModel)] = []
    var onDataUpdate: (() -> Void)?
    var onError: ((String) -> Void)?
    
    private let db = Firestore.firestore()
    
    func fetchAllUsersContents() {
        db.collection("users").getDocuments { [weak self] snapshot, error in
            if let error = error {
                self?.onError?("Kullanıcılar alınamadı: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            
            let group = DispatchGroup()
            self?.feedContents.removeAll()
            
            for userDoc in documents {
                let userId = userDoc.documentID
                let userName = userDoc.data()["name"] as? String ?? "Bilinmeyen"
                
                group.enter()
                self?.db.collection("users")
                    .document(userId)
                    .collection("content")
                    .order(by: "createdAt", descending: true)
                    .getDocuments { contentSnap, err in
                        if let err = err {
                            print("Content error: \(err.localizedDescription)")
                        } else {
                            let contents = contentSnap?.documents.compactMap {
                                try? $0.data(as: ContentModel.self)
                            } ?? []
                            contents.forEach { content in
                                self?.feedContents.append((userName: userName, content: content))
                            }
                        }
                        group.leave()
                    }
            }
            
            group.notify(queue: .main) {
                self?.feedContents.sort { ($0.content.createdAt ?? Date()) > ($1.content.createdAt ?? Date()) }
                self?.onDataUpdate?()
            }
        }
    }
    
}
