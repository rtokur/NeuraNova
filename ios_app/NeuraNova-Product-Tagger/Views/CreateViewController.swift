//
//  CreateViewController.swift
//  NeuraNova-Product-Tagger
//
//  Created by Rumeysa Tokur on 29.07.2025.
//

import UIKit

class CreateViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: - UI Elements
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.backgroundColor = .secondarySystemBackground
        imageView.image = UIImage(systemName: "photo.on.rectangle.angled")
        imageView.tintColor = .gray
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var chooseButton: UIButton = {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.filled()
        config.title = "Choose Photo"
        config.image = UIImage(systemName: "photo.on.rectangle")
        config.imagePadding = 8
        config.cornerStyle = .capsule
        config.baseBackgroundColor = .black
        config.baseForegroundColor = .white
        button.configuration = config
        button.addTarget(self, action: #selector(openPickerOptions), for: .touchUpInside)
        return button
    }()
    
    private lazy var generateButton: UIButton = {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.filled()
        config.title = "Generate with AI"
        config.image = UIImage(systemName: "wand.and.stars")
        config.imagePadding = 8
        config.cornerStyle = .capsule
        config.baseBackgroundColor = .black
        config.baseForegroundColor = .white
        button.configuration = config
        button.isHidden = true
        button.addTarget(self, action: #selector(generateWithAI), for: .touchUpInside)
        return button
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.filled()
        config.title = "Delete Photo"
        config.image = UIImage(systemName: "trash")
        config.imagePadding = 8
        config.baseBackgroundColor = .red
        config.baseForegroundColor = .white
        config.cornerStyle = .capsule
        button.configuration = config
        button.isHidden = true
        button.addTarget(self, action: #selector(deletePhoto), for: .touchUpInside)
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
        title = "Create Content"
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        [imageView, chooseButton, generateButton, deleteButton].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    func setupConstraints(){
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalTo(scrollView.contentLayoutGuide)
            make.leading.trailing.equalTo(scrollView.frameLayoutGuide)
        }
        
        imageView.snp.makeConstraints { make in
            make.height.equalTo(200)
            make.leading.trailing.equalToSuperview().inset(30)
        }
        
        [chooseButton, generateButton, deleteButton].forEach { button in
            button.snp.makeConstraints { make in
                make.height.equalTo(50)
                make.leading.trailing.equalToSuperview().inset(30)
            }
        }
    }
    
    //MARK: - Functions
    private func openPicker(source: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = source
        picker.allowsEditing = false
        present(picker, animated: true)
    }
    
    //MARK: - Actions
    @objc private func openPickerOptions() {
        let alert = UIAlertController(title: "Choose Option", message: nil, preferredStyle: .actionSheet)
        
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
    
    @objc private func deletePhoto() {
        imageView.image = UIImage(systemName: "photo.on.rectangle.angled")
        chooseButton.isHidden = false
        generateButton.isHidden = true
        deleteButton.isHidden = true
    }
    
    @objc private func generateWithAI() {
        print("AI generation triggered (mock placeholder)")
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
