//
//  CreateViewController.swift
//  NeuraNova-Product-Tagger
//
//  Created by Rumeysa Tokur on 29.07.2025.
//

import UIKit

class CreateViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private let viewModel = CreateViewModel()
    private var currentMetaData: ContentModel?
    
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
        config.baseBackgroundColor = .black
        config.baseForegroundColor = .white
        button.configuration = config
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 15
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
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .black
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
    
    // Activity Indicator
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // Metadata Labels
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let tagsLabel = UILabel()
    
    private lazy var metadataStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, tagsLabel])
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
        stack.isHidden = true
        return stack
    }()
    
    // Approve Button
    private lazy var approveButton: UIButton = {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.filled()
        config.title = "Approve & Save"
        config.image = UIImage(systemName: "checkmark.circle")
        config.imagePadding = 8
        config.baseBackgroundColor = .green
        config.baseForegroundColor = .white
        config.cornerStyle = .capsule
        button.configuration = config
        button.isHidden = true
        button.addTarget(self, action: #selector(approveMetadata), for: .touchUpInside)
        return button
    }()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupGradientBackground()
        bindViewModel()
    }
    
    //MARK: - Setup Methods
    func setupViews(){
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        scrollView.addSubview(stackView)
        [imageView, chooseButton, generateButton, deleteButton, metadataStack, approveButton, activityIndicator].forEach {
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
        [chooseButton, generateButton, deleteButton, approveButton].forEach { button in
            button.snp.makeConstraints { make in
                make.height.equalTo(50)
                make.leading.trailing.equalToSuperview().inset(30)
            }
        }
        
        metadataStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(50)
        }
    }
    //MARK: - Functions
    private func bindViewModel() {
        viewModel.onLoadingStateChange = { [weak self] isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self?.activityIndicator.startAnimating()
                    self?.metadataStack.isHidden = true
                    self?.approveButton.isHidden = true
                } else {
                    self?.activityIndicator.stopAnimating()
                }
            }
        }
        
        viewModel.onMetadataUpdate = { [weak self] metadata in
            DispatchQueue.main.async {
                self?.currentMetaData = metadata
                self?.titleLabel.text = "Title: \(metadata.title)"
                self?.descriptionLabel.text = "Description: \(metadata.description)"
                self?.tagsLabel.text = "Tags: \(metadata.tags)"
                self?.metadataStack.isHidden = false
                self?.approveButton.isHidden = false
            }
        }
        
        viewModel.onError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.showAlert(title: "Hata", message: errorMessage)
            }
        }
        
        viewModel.onSaveSuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.showAlert(title: "Başarılı", message: "Metadata kaydedildi.")
            }
        }
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
    
    private func openPicker(source: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = source
        picker.allowsEditing = false
        present(picker, animated: true)
    }
    
    @objc private func deletePhoto() {
        imageView.image = UIImage(systemName: "photo.on.rectangle.angled")
        chooseButton.isHidden = false
        generateButton.isHidden = true
        deleteButton.isHidden = true
        metadataStack.isHidden = true
        approveButton.isHidden = true
    }
    
    @objc private func generateWithAI() {
        guard let selectedImage = imageView.image, selectedImage != UIImage(systemName: "photo.on.rectangle.angled") else {
            showAlert(title: "Uyarı", message: "Lütfen önce bir fotoğraf seçin.")
            return
        }
        viewModel.generateMetadata(from: selectedImage)
    }
    
    @objc private func approveMetadata() {
        guard let metadata = currentMetaData else { return }
        viewModel.saveMetadata(metadata)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
    
    //MARK: - UIImagePickerControllerDelegate
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
