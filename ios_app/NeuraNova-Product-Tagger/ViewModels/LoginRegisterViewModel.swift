//
//  LoginRegisterViewModel.swift
//  NeuraNova-Product-Tagger
//
//  Created by Rumeysa Tokur on 30.07.2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class LoginRegisterViewModel {
    
    var onLoadingStateChange: ((Bool) -> Void)?
    var onError: ((String) -> Void)?
    var onSuccess: ((UserModel) -> Void)?
    
    private let db = Firestore.firestore()
    
    func login(email: String, password: String) {
        guard !email.isEmpty, !password.isEmpty else {
            onError?("Please fill in all fields")
            return
        }
        
        onLoadingStateChange?(true)
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            self?.onLoadingStateChange?(false)
            if let error = error {
                self?.onError?(error.localizedDescription)
            } else if let uid = result?.user.uid {
                self?.fetchUser(uid: uid)
            }
        }
    }
    
    func register(name: String, email: String, password: String) {
        guard !name.isEmpty, !email.isEmpty, !password.isEmpty else {
            onError?("Please fill in all fields")
            return
        }
        
        onLoadingStateChange?(true)
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.onLoadingStateChange?(false)
                self?.onError?(error.localizedDescription)
            } else if let uid = result?.user.uid {
                self?.saveUserInfo(uid: uid, name: name, email: email)
            }
        }
    }
    
    private func saveUserInfo(uid: String, name: String, email: String) {
        let userData: [String: Any] = [
            "uid": uid,
            "name": name,
            "email": email,
            "createdAt": Timestamp(date: Date())
        ]
        
        db.collection("users").document(uid).setData(userData) { [weak self] error in
            if let error = error {
                self?.onLoadingStateChange?(false)
                self?.onError?(error.localizedDescription)
            } else {
                self?.fetchUser(uid: uid)
            }
        }
    }
    
    private func fetchUser(uid: String) {
        db.collection("users").document(uid).getDocument { [weak self] document, error in
            self?.onLoadingStateChange?(false)
            if let error = error {
                self?.onError?(error.localizedDescription)
            } else if let data = document?.data(), let user = UserModel(data: data) {
                self?.onSuccess?(user)
            }
        }
    }
}
