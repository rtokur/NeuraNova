//
//  HomeViewController.swift
//  NeuraNova-Product-Tagger
//
//  Created by Rumeysa Tokur on 29.07.2025.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let user: UserModel
    private let viewModel = HomeViewModel()
    private let loginViewModel = LoginRegisterViewModel()
    
    //MARK: - UI Elements
    private let iconStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var iconImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .blue
        return imageView
    }()
    
    private lazy var iconLabel : UILabel = {
        let label = UILabel()
        label.text = "NeuraNova"
        label.textColor = .white
        return label
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.fill")
        imageView.tintColor = .white
        imageView.layer.borderColor = UIColor(named: "484849")!.cgColor
        imageView.layer.borderWidth = 5
        imageView.layer.cornerRadius = 10
        imageView.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
            imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: FeedCollectionViewCell.identifier)
        cv.delegate = self
        cv.showsVerticalScrollIndicator = false
        cv.dataSource = self
        cv.backgroundColor = .clear
        return cv
    }()
    
    // MARK: - Init
    init(user: UserModel) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        bindViewModel()
        setupGradientBackground()
    }
    
    //MARK: - Setup Methods
    func setupViews(){
        
        view.addSubview(iconStackView)
        iconStackView.addArrangedSubview(iconImageView)
        iconStackView.addArrangedSubview(iconLabel)
        view.addSubview(profileImageView)
        view.addSubview(collectionView)
    }
    
    func setupConstraints(){
        iconStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().inset(30)
            make.height.equalTo(40)
        }
        iconImageView.snp.makeConstraints { make in
            make.height.width.equalTo(40)
        }
        profileImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(30)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.width.equalTo(70)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview().inset(20)
        }
    }
    
    //MARK: - Functions
    private func bindViewModel() {
        viewModel.onDataUpdate = { [weak self] in
            self?.collectionView.reloadData()
            self?.collectionView.snp.updateConstraints { make in
                make.height.equalTo(((self?.collectionView.collectionViewLayout.collectionViewContentSize.height)!))
            }
        }
        
        viewModel.onError = { error in
            print("Error: \(error)")
        }
        
        loginViewModel.onSignOut = { [weak self] in
            guard let self = self else { return }
            let loginVC = LoginViewController()
            navigationController?.pushViewController(loginVC, animated: true)
        }
    }
    
    @objc private func profileImageTapped() {
        let alert = UIAlertController(title: "Hesap",
                                      message: "Çıkış yapmak istiyor musunuz?",
                                      preferredStyle: .actionSheet)
        
        let logoutAction = UIAlertAction(title: "Çıkış Yap", style: .destructive) { _ in
            self.loginViewModel.signOut()
        }
        
        let cancelAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)
        
        alert.addAction(logoutAction)
        alert.addAction(cancelAction)
        
        if let popover = alert.popoverPresentationController {
            popover.sourceView = profileImageView
            popover.sourceRect = profileImageView.bounds
        }
        
        present(alert, animated: true)
    }

}

// MARK: - CollectionView Delegate & DataSource
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCollectionViewCell.identifier, for: indexPath) as? FeedCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(userName: "Rumeysa", date: "2h", description: "sdfsdfdsgsdgsdgjsdfkjasflkjadflkjselkjfkasldjjjjjjasdfskldjflksdlfknsdlknvlksndvnsvnlsdnvskldmvlsdmvls", image: UIImage(named: "GetStarted"))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let tabBarController = tabBarController as? MainTabBarController else { return }
        
        if velocity.y > 0 {
            tabBarController.setTabBar(hidden: true)
        } else if velocity.y < 0 { 
            tabBarController.setTabBar(hidden: false)
        }
    }

}
