//
//  HistoryViewController.swift
//  NeuraNova-Product-Tagger
//
//  Created by Rumeysa Tokur on 29.07.2025.
//

import UIKit
import SnapKit

class HistoryViewController: UIViewController {
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    //MARK: - Setup Methods
    func setupViews(){
        view.backgroundColor = .black.withAlphaComponent(0.8)
    }

    func setupConstraints(){
        
    }
    
}
