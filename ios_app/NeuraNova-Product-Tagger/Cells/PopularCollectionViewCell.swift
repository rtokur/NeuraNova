//
//  PopularCollectionViewCell.swift
//  NeuraNova-Product-Tagger
//
//  Created by Rumeysa Tokur on 6.08.2025.
//

import UIKit
import Kingfisher

class PopularCollectionViewCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 15
        iv.clipsToBounds = true
        iv.backgroundColor = .gray
        return iv
    }()
    
    private let gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.75).cgColor
        ]
        gradient.locations = [0.3, 1.0]
        return gradient
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 2
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientFrame()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(imageView)
        imageView.layer.addSublayer(gradientLayer)
        contentView.addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(10)
        }
    }
    
    private func updateGradientFrame() {
        gradientLayer.frame = CGRect(
            x: 0,
            y: imageView.bounds.height * 0.3,
            width: imageView.bounds.width,
            height: imageView.bounds.height * 0.7
        )
    }
    
    func configure(with model: ContentModel) {
        titleLabel.text = model.title
        if let url = URL(string: model.imageUrl ?? "") {
            imageView.kf.setImage(with: url, completionHandler: { [weak self] _ in
                self?.updateGradientFrame()
            })
        }
    }
}
