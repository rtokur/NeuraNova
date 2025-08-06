//
//  TagCollectionViewCell.swift
//  NeuraNova-Product-Tagger
//
//  Created by Rumeysa Tokur on 6.08.2025.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {
    
    private let gradientLayer = CAGradientLayer()
    
    private let label: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        lbl.textColor = .white
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let bgView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true 
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupShadow()
        setupViews()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupViews() {
        contentView.addSubview(bgView)
        bgView.addSubview(label)
        
        bgView.layer.insertSublayer(gradientLayer, at: 0)
        
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
    }
    
    private func setupShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.masksToBounds = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bgView.bounds
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 10).cgPath
    }
    
    func configure(with text: String) {
        label.text = "#\(text)"

        gradientLayer.colors = [
            UIColor(named: "484849")?.cgColor ?? UIColor.darkGray.cgColor,
            UIColor(named: "2F2F2F")?.cgColor ?? UIColor.black.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
    }
}
