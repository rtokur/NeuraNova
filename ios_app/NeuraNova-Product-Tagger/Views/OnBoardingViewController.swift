//
//  OnBoardingViewController.swift
//  NeuraNova-Product-Tagger
//
//  Created by Rumeysa Tokur on 4.08.2025.
//

import UIKit

class OnBoardingViewController: UIViewController {
    //MARK: - UI Elements
    private lazy var backgroundImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "GetStarted")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let gradientTopView: UIView = {
        let view = UIView()
        return view
    }()
    
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
    
    private let gradientView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let welcomeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        return stackView
    }()
    
    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 55)
        label.textColor = .white
        label.text = "Hola, welcome!"
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .white
        label.text = "Share your thoughts, connect with friends, and discover the world."
        label.textAlignment = .left
        label.numberOfLines = 3
        return label
    }()
    
    private lazy var getStartedButton: UIButton = {
        let button = UIButton()
        button.setTitle("Get started", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var signInLabel: UILabel = {
        let label = UILabel()
        let fullText = "Already on NeuraNova? Sign in"
        let attributedText = NSMutableAttributedString(
            string: fullText,
            attributes: [
                .foregroundColor: UIColor.white,
                .font: UIFont.systemFont(ofSize: 14)
            ]
        )
        
        if let range = fullText.range(of: "Sign in") {
            let nsRange = NSRange(range, in: fullText)
            attributedText.addAttributes([
                .foregroundColor: UIColor.white,
                .font: UIFont.boldSystemFont(ofSize: 14),
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ], range: nsRange)
        }
        
        label.attributedText = attributedText
        label.isUserInteractionEnabled = true
        label.textAlignment = .center
        return label
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(signInTapped))
        signInLabel.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let gradientLayer = gradientView.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = gradientView.bounds
        } else {
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [
                UIColor.black.cgColor,
                UIColor.clear.cgColor
            ]
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.frame = gradientView.bounds
            gradientView.layer.insertSublayer(gradientLayer, at: 0)
        }
        
        if let topLayer = gradientTopView.layer.sublayers?.first as? CAGradientLayer {
            topLayer.frame = gradientTopView.bounds
        } else {
            let topLayer = CAGradientLayer()
            topLayer.colors = [
                UIColor.black.cgColor,
                UIColor.clear.cgColor
            ]
            topLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            topLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
            topLayer.frame = gradientTopView.bounds
            gradientTopView.layer.insertSublayer(topLayer, at: 0)
        }
    }
    //MARK: - Setup Methods
    func setupViews(){
        view.addSubview(backgroundImageView)
        view.addSubview(gradientTopView)
        view.addSubview(iconStackView)
        iconStackView.addArrangedSubview(iconImageView)
        iconStackView.addArrangedSubview(iconLabel)
        view.addSubview(gradientView)
        view.addSubview(welcomeStackView)
        welcomeStackView.addArrangedSubview(welcomeLabel)
        welcomeStackView.addArrangedSubview(descriptionLabel)
        welcomeStackView.addArrangedSubview(getStartedButton)
        welcomeStackView.addArrangedSubview(signInLabel)
    }
    
    func setupConstraints(){
        backgroundImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(100)
        }
        gradientTopView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
        iconStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().inset(30)
            make.height.equalTo(40)
        }
        iconImageView.snp.makeConstraints { make in
            make.height.width.equalTo(40)
        }
        gradientView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        welcomeStackView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(60)
        }
        welcomeLabel.snp.makeConstraints { make in
            make.height.equalTo(140)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.height.equalTo(90)
        }
        getStartedButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        signInLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
    }
    
    //MARK: - Actions
    @objc private func signInTapped() {
        let loginVC = LoginViewController()
        navigationController?.pushViewController(loginVC, animated: true)
    }
}
