//
//  HistoryViewController.swift
//  NeuraNova-Product-Tagger
//
//  Created by Rumeysa Tokur on 29.07.2025.
//

import UIKit
import SnapKit
import Kingfisher

class HistoryViewController: UIViewController {
    
    private let viewModel = CreateViewModel()
    private var contents: [ContentModel] = []
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 8
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 40, height: 120)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.delegate = self
        cv.dataSource = self
        cv.register(HistoryCollectionViewCell.self, forCellWithReuseIdentifier: "HistoryCell")
        return cv
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        view.backgroundColor = .white
        setupGradientBackground()
        bindViewModel()
        
        viewModel.fetchUserContents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchUserContents()
    }
    
    //MARK: - Setup Methods
    func setupViews() {
        view.addSubview(collectionView)
    }
    
    func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        viewModel.onContentsUpdate = { [weak self] in
            self?.contents = self?.viewModel.contents ?? []
            self?.collectionView.reloadData()
        }
        
        viewModel.onSaveSuccess = { [weak self] in
            self?.showSnackbar(message: "İçerik başarıyla silindi")
        }
    }
}

//MARK: - CollectionView Delegate & DataSource
extension HistoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HistoryCell", for: indexPath) as! HistoryCollectionViewCell
        cell.configure(with: contents[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedContent = contents[indexPath.item]
        
        if let url = URL(string: selectedContent.imageUrl ?? "") {
            KingfisherManager.shared.retrieveImage(with: url) { result in
                switch result {
                case .success(let value):
                    let detailVC = ContentDetailViewController(selectedImage: value.image, contentModel: selectedContent)
                    self.navigationController?.pushViewController(detailVC, animated: true)
                case .failure(let error):
                    print("Görsel yüklenemedi: \(error.localizedDescription)")
                }
            }
        }
    }
}
