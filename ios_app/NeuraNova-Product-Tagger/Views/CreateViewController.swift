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
    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.alpha = 0.6
        view.isHidden = true
        return view
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
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
    
    private let choosePhotoView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "484849")!
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let chooseStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var generateLabel: UILabel = {
        let label = UILabel()
        label.text = "Get the image you want"
        label.font = .boldSystemFont(ofSize: 17)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var chooseButton: UIButton = {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.filled()
        config.attributedTitle = AttributedString(NSAttributedString(string: "Generate Your Content", attributes: [.font: UIFont.boldSystemFont(ofSize: 15)]))
        config.image = UIImage(systemName: "plus")
        config.imagePadding = 8
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .black
        button.configuration = config
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(openPickerOptions), for: .touchUpInside)
        return button
    }()
    
    private let popularStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var popularLabel: UILabel = {
        let label = UILabel()
        label.text = "Popular Contents"
        label.font = .boldSystemFont(ofSize: 15)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    private lazy var seeAllButton: UIButton = {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.filled()
        config.attributedTitle = AttributedString(NSAttributedString(string: "See All", attributes: [.font: UIFont.systemFont(ofSize: 13)]))
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .clear
        button.configuration = config
        button.addTarget(self, action: #selector(navigateToHistory), for: .touchUpInside)
        return button
    }()
    
    private lazy var popularCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 15
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(PopularCollectionViewCell.self, forCellWithReuseIdentifier: "PopularCollectionViewCell")
        return collectionView
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupGradientBackground()
        viewModel.onContentsUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.popularCollectionView.reloadData()
                
            }
        }
        
        viewModel.fetchUserContents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchUserContents()
    }
    
    //MARK: - Setup Methods
    func setupViews(){
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(choosePhotoView)
        choosePhotoView.addSubview(chooseStackView)
        chooseStackView.addArrangedSubview(generateLabel)
        chooseStackView.addArrangedSubview(chooseButton)
        stackView.addArrangedSubview(popularStackView)
        popularStackView.addArrangedSubview(popularLabel)
        popularStackView.addArrangedSubview(seeAllButton)
        stackView.addArrangedSubview(popularCollectionView)
        
        view.addSubview(blurEffectView)
        blurEffectView.contentView.addSubview(activityIndicator)
    }
    
    func setupConstraints(){
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalTo(scrollView.contentLayoutGuide)
            make.leading.trailing.equalTo(scrollView.frameLayoutGuide)
        }
        choosePhotoView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(140)
        }
        chooseStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
        generateLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        chooseButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalToSuperview()
        }
        popularStackView.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalToSuperview()
        }
        popularLabel.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
        seeAllButton.snp.makeConstraints { make in
            make.width.equalTo(70)
        }
        popularCollectionView.snp.makeConstraints { make in
            make.height.equalTo(200)
            make.width.equalToSuperview()
        }
        
        blurEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
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
    
    @objc private func navigateToHistory() {
        if let tabBar = tabBarController as? MainTabBarController {
            tabBar.selectedIndex = TabBarButton.history.rawValue
            tabBar.tabbarView.setSelectedIndex(TabBarButton.history.rawValue)
        }
    }
    
    private func openPicker(source: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = source
        picker.allowsEditing = false
        present(picker, animated: true)
    }
    
    private func showLoading(_ show: Bool) {
        if show {
            blurEffectView.isHidden = false
            activityIndicator.startAnimating()
        } else {
            UIView.animate(withDuration: 0.3) {
                self.blurEffectView.alpha = 0
            } completion: { _ in
                self.blurEffectView.isHidden = true
                self.blurEffectView.alpha = 0.6
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
    //MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selected = info[.originalImage] as? UIImage {
            viewModel.onLoadingStateChange = { [weak self] isLoading in
                DispatchQueue.main.async {
                    self?.showLoading(isLoading)
                }
            }
            
            viewModel.onMetadataUpdate = { [weak self] generatedContent in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.showLoading(false)
                    let detailVC = ContentDetailViewController(
                        selectedImage: selected,
                        contentModel: generatedContent
                    )
                    self.navigationController?.pushViewController(detailVC, animated: true)
                }
            }
            
            viewModel.onError = { [weak self] errorMessage in
                DispatchQueue.main.async {
                    self?.showLoading(false)
                    self?.showAlert(title: "Hata", message: errorMessage)
                }
            }
            
            viewModel.generateMetadata(from: selected)
        }
        dismiss(animated: true)
    }
}

extension CreateViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.contents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularCollectionViewCell", for: indexPath) as! PopularCollectionViewCell
        let content = viewModel.contents[indexPath.item]
        cell.configure(with: content)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedContent = viewModel.contents[indexPath.item]
        
        if let url = selectedContent.imageUrl,
           let URL = URL(string: url){
            let detailVC = ContentDetailViewController(selectedImage: UIImage(), contentModel: selectedContent)
            
            navigationController?.pushViewController(detailVC, animated: true)
        } else {
            let detailVC = ContentDetailViewController(selectedImage: UIImage(), contentModel: selectedContent)
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 200)
    }
    
}
