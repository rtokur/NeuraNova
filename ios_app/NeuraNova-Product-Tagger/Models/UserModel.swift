//
//  File.swift
//  NeuraNova-Product-Tagger
//
//  Created by Rumeysa Tokur on 31.07.2025.
//

import Foundation

struct UserModel {
    let uid: String
    let name: String
    let email: String
    
    init?(data: [String: Any]) {
        guard let uid = data["uid"] as? String,
              let name = data["name"] as? String,
              let email = data["email"] as? String else { return nil }
        self.uid = uid
        self.name = name
        self.email = email
    }
}
