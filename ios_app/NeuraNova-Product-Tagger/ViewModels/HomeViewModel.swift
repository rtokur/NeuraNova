//
//  HomeViewModel.swift
//  NeuraNova-Product-Tagger
//
//  Created by Rumeysa Tokur on 31.07.2025.
//

import Foundation

final class HomeViewModel {
    
    var onDataUpdate: (() -> Void)?
    var onError: ((String) -> Void)?
    
    private(set) var contentModels: [ContentModel] = []
    
}
