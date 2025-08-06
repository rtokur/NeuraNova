//
//  ContentDetailViewController.swift
//  NeuraNova-Product-Tagger
//
//  Created by Rumeysa Tokur on 5.08.2025.
//

import UIKit

class ContentDetailViewController: UIViewController {
    
    private let selectedImage: UIImage
    private let contentModel: ContentModel
    private let viewModel = CreateViewModel()
    private var tags: [String] = []
    private var didUpdateTagHeight = false
    
    // MARK: UI Elements
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .clear
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        return button
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 10
        return iv
    }()
    
    private lazy var tagsCollectionView: UICollectionView = {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.delegate = self
        cv.dataSource = self
        cv.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: "TagCell")
        return cv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = .gray
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private lazy var actionStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 15
        stack.distribution = .fillEqually
        return stack
    }()
    
    private var deleteButtonActivity: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.filled()
        config.attributedTitle = AttributedString(NSAttributedString(string: "Sil", attributes: [.font: UIFont.boldSystemFont(ofSize: 15)]))
        config.baseBackgroundColor = UIColor(named: "484849")
        config.baseForegroundColor = .white
        config.cornerStyle = .large
        button.configuration = config
        button.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        return button
    }()
    
    private var saveButtonActivity: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.filled()
        config.attributedTitle = AttributedString(NSAttributedString(string: "Kaydet", attributes: [.font: UIFont.boldSystemFont(ofSize: 15)]))
        config.baseBackgroundColor = UIColor(named: "484849")
        config.baseForegroundColor = .white
        config.cornerStyle = .large
        button.configuration = config
        button.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        return button
    }()
    
    // MARK: Init
    init(selectedImage: UIImage, contentModel: ContentModel) {
        self.selectedImage = selectedImage
        self.contentModel = contentModel
        self.tags = contentModel.tags ?? []
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()

        setupGradientBackground()
        if contentModel.id != nil {
            saveButton.isHidden = true
        } else {
            saveButton.isHidden = false
        }
        bindViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        guard !didUpdateTagHeight else { return }
        didUpdateTagHeight = true
        
        tagsCollectionView.layoutIfNeeded()
        
        let contentHeight = tagsCollectionView.collectionViewLayout.collectionViewContentSize.height
        
        tagsCollectionView.snp.updateConstraints { make in
            make.height.equalTo(contentHeight).priority(.required)
        }
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(backButton)
        view.addSubview(imageView)
        view.addSubview(tagsCollectionView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        actionStackView.addArrangedSubview(deleteButton)
        deleteButton.addSubview(deleteButtonActivity)
        actionStackView.addArrangedSubview(saveButton)
        saveButton.addSubview(saveButtonActivity)
        view.addSubview(actionStackView)
        
        if let title = contentModel.title,
           let description = contentModel.description,
           let tags = contentModel.tags {
            titleLabel.text = title
            descriptionLabel.text = description
            self.tags = tags
            tagsCollectionView.reloadData()
        }
        
        if let url = contentModel.imageUrl,
           let URL = URL(string: url) {
            imageView.kf.setImage(with: URL, placeholder: selectedImage)
        } else {
            imageView.image = selectedImage
        }
        
    }
    
    private func setupConstraints() {
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().inset(10)
            make.height.width.equalTo(50)
        }
        imageView.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(300)
        }
        tagsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(100)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(tagsCollectionView.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        saveButtonActivity.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        deleteButtonActivity.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        actionStackView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
    private func bindViewModel(){
        viewModel.onSaveSuccess = { [weak self] in
            self?.saveButton.showLoading(false)
            self?.saveButton.setTitle("Kaydedildi", for: .normal)
            self?.saveButton.isEnabled = false
        }
        
        viewModel.onDeleteSuccess = { [weak self] in
            self?.deleteButton.showLoading(false)
            self?.deleteButton.setTitle("Silindi", for: .normal)
            self?.deleteButton.isEnabled = false
        }
        
        viewModel.onError = { [weak self] errorMessage in
            let alert = UIAlertController(title: "Hata", message: errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .default))
            self?.present(alert, animated: true)
        }
    }
    
    @objc private func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func deleteAction() {
        let alert = UIAlertController(title: "Silmek istiyor musunuz?", message: nil, preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Evet", style: .destructive) { _ in
            self.deleteButton.showLoading(true)
            
            if self.contentModel.imageUrl == nil {
                self.navigationController?.popViewController(animated: true)
            } else {
                self.viewModel.deleteContent(self.contentModel)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Hayır", style: .cancel)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    @objc private func saveAction() {
        saveButton.showLoading(true)
        
        let updatedModel = ContentModel(
            title: titleLabel.text ?? "",
            description: descriptionLabel.text ?? "",
            tags: tags,
            imageUrl: contentModel.imageUrl ?? ""
        )
        
        viewModel.saveMetadata(updatedModel, image: imageView.image)
    }
}

// MARK: - CollectionView
extension ContentDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCollectionViewCell
        cell.configure(with: tags[indexPath.item])
        return cell
    }
}

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }
        return attributes
    }
}
