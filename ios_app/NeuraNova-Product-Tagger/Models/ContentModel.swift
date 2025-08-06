//
//  ContentModel.swift
//  NeuraNova-Product-Tagger
//
//  Created by Rumeysa Tokur on 31.07.2025.
//

import Foundation
import FirebaseFirestore

struct ContentModel: Identifiable, Codable {
    @DocumentID var id: String?
    
    var title: String?
    var description: String?
    var tags: [String]?
    var imageUrl: String?
    
    @ServerTimestamp var createdAt: Date?
    
    init(title: String? = nil,
         description: String? = nil,
         tags: [String]? = nil,
         imageUrl: String? = nil,
         createdAt: Date? = nil) {
        self.title = title
        self.description = description
        self.tags = tags
        self.imageUrl = imageUrl
        self.createdAt = createdAt
    }
}

struct APIContentModel: Codable {
    let title: String
    let description: String
    let tags: [String]
}

