//
//  HomeViewController.swift
//  NeuraNova-Product-Tagger
//
//  Created by Rumeysa Tokur on 29.07.2025.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: - UI Elements
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Welcome to NeuraNova"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    //MARK: - Setup Methods
    func setupViews(){
        title = "Home"
        
        view.backgroundColor = .white
        view.addSubview(label)
    }
    
    func setupConstraints(){
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
}
