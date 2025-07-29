//
//  CreateViewController.swift
//  NeuraNova-Product-Tagger
//
//  Created by Rumeysa Tokur on 29.07.2025.
//

import UIKit

class CreateViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: - UI Elements
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .secondarySystemBackground
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let chooseButton: UIButton = {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.filled()
        config.title = "Choose Photo"
        config.image = UIImage(systemName: "photo.on.rectangle")
        config.imagePadding = 8
        config.baseBackgroundColor = .systemBlue
        config.baseForegroundColor = .white
        button.configuration = config
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let generateButton: UIButton = {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.filled()
        config.title = "Generate with AI"
        config.image = UIImage(systemName: "wand.and.stars")
        config.imagePadding = 8
        config.baseBackgroundColor = .black
        config.baseForegroundColor = .white
        button.configuration = config
        button.layer.cornerRadius = 8
        button.isHidden = true
        return button
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.filled()
        config.title = "Delete Photo"
        config.image = UIImage(systemName: "trash")
        config.imagePadding = 8
        config.baseBackgroundColor = .red
        config.baseForegroundColor = .white
        button.configuration = config
        button.layer.cornerRadius = 8
        button.isHidden = true
        return button
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    //MARK: - Setup Methods
    func setupViews(){
        view.backgroundColor = .black.withAlphaComponent(0.8)
        view.addSubview(imageView)
        view.addSubview(chooseButton)
        view.addSubview(generateButton)
        view.addSubview(deleteButton)
        
        chooseButton.addTarget(self, action: #selector(openPickerOptions), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deletePhoto), for: .touchUpInside)
    }
    
    func setupConstraints(){
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(250)
        }
        
        chooseButton.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(180)
            make.height.equalTo(44)
        }
        
        generateButton.snp.makeConstraints { make in
            make.top.equalTo(chooseButton.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(44)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(generateButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(44)
        }
    }
    
    //MARK: - Actions
    @objc private func openPickerOptions() {
        let alert = UIAlertController(title: "Choose Option", message: nil, preferredStyle: .actionSheet)
        
        // Kamera seçeneği
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                self.openPicker(source: .camera)
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            self.openPicker(source: .photoLibrary)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    
    private func openPicker(source: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = source
        picker.allowsEditing = false
        present(picker, animated: true)
    }
    
    @objc private func deletePhoto() {
        imageView.image = nil
        chooseButton.isHidden = false
        generateButton.isHidden = true
        deleteButton.isHidden = true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selected = info[.originalImage] as? UIImage {
            imageView.image = selected
            chooseButton.isHidden = true
            generateButton.isHidden = false
            deleteButton.isHidden = false
        }
        dismiss(animated: true)
    }
}
