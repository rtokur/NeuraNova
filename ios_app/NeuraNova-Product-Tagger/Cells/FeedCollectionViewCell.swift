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
        stackView.distribution = .fill
        return stackView
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
        }
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    private let dotView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.cornerRadius = 3
        view.snp.makeConstraints { make in
            make.width.height.equalTo(6)
        }
        return view
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .gray
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
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
        
        hStackView.addArrangedSubview(profileImageView)
        hStackView.addArrangedSubview(userNameLabel)
        hStackView.addArrangedSubview(dotView)
        hStackView.addArrangedSubview(dateLabel)
        userNameLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        dotView.setContentHuggingPriority(.required, for: .horizontal)
        dateLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        dateLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        descriptionLabel.setContentHuggingPriority(.required, for: .vertical)
        descriptionLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(feedImageView)
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        hStackView.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        feedImageView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(feedImageView.snp.width).multipliedBy(0.75)
        }
    }
    
    func configure(userName: String, date: String, description: String, imageUrl: String, tags: [String]) {
        userNameLabel.text = userName
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d/yyyy, HH:mm"
        if let actualDate = dateFormatter.date(from: date) {
            let relativeFormatter = RelativeDateTimeFormatter()
            relativeFormatter.unitsStyle = .abbreviated
            dateLabel.text = relativeFormatter.localizedString(for: actualDate, relativeTo: Date())
        } else {
            dateLabel.text = date
        }
        
        let attributedText = NSMutableAttributedString(
            string: "\(description)\n",
            attributes: [.foregroundColor: UIColor.lightGray,
                         .font: UIFont.systemFont(ofSize: 14)]
        )
        
        let tagsText = tags.map { "#\($0)" }.joined(separator: " ")
        let tagsAttributed = NSAttributedString(
            string: tagsText,
            attributes: [.foregroundColor: UIColor.brown,
                         .font: UIFont.systemFont(ofSize: 14)]
        )
        
        attributedText.append(tagsAttributed)
        descriptionLabel.attributedText = attributedText
        
        if let url = URL(string: imageUrl) {
            feedImageView.kf.setImage(with: url)
        }
        
        profileImageView.image = UIImage(systemName: "person.circle.fill")
        profileImageView.tintColor = .white
    }
    
}
