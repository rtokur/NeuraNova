//
//  FeedCollectionViewCell.swift
//  NeuraNova-Product-Tagger
//
//  Created by Rumeysa Tokur on 31.07.2025.
//

import UIKit
import SnapKit

class FeedCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "FeedCell"
    
    private var feedImageHeightConstraint: Constraint?
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private let hStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.alignment = .center
        return stackView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .gray
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let feedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.backgroundColor = .clear
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(hStackView)
        hStackView.addArrangedSubview(userNameLabel)
        hStackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(feedImageView)
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(10)
        }
        
        feedImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            
            feedImageHeightConstraint = make.height.lessThanOrEqualTo(400).constraint
        }
    }
    
    func configure(userName: String, date: String, description: String, image: UIImage?) {
        userNameLabel.text = userName
        dateLabel.text = date
        descriptionLabel.text = description
        
        if let img = image {
            feedImageView.image = img
            
            let aspectRatio = img.size.height / img.size.width
            let targetWidth = UIScreen.main.bounds.width - 30
            let calculatedHeight = targetWidth * aspectRatio
            
            feedImageHeightConstraint?.update(offset: min(calculatedHeight, 400))
        } else {
            feedImageHeightConstraint?.update(offset: 0)
        }
    }
}

