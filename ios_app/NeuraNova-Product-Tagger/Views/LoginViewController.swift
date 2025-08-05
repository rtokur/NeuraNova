//
//  LoginRegisterViewController.swift
//  NeuraNova-Product-Tagger
//
//  Created by Rumeysa Tokur on 30.07.2025.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let viewModel = LoginRegisterViewModel()
    
    //MARK: - UI Elements
    private let scrollView = UIScrollView()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        return stackView
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.color = .black
        return spinner
    }()
    
    private let welcomeView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let welcomeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome Back"
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 35)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Log in to continue your journey."
        label.textColor = .white
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 30
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        return stackView
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Login","Register"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        return segmentedControl
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.textColor = .black
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Full Name"
        textField.textColor = .black
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.setLeftPaddingPoints(12)
        return textField
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.textColor = .black
        return label
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "E-mail"
        textField.textColor = .black
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.autocapitalizationType = .none
        textField.setLeftPaddingPoints(12)
        return textField
    }()
    
    private lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password"
        label.textColor = .black
        return label
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "********"
        textField.textColor = .black
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        textField.setLeftPaddingPoints(12)
        return textField
    }()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(actionTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var registerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupViews()
        setupConstraints()
        updateForm(for: 0)
        bindViewModel()
    }
    
    //MARK: - Setup Methods
    func setupViews(){
        view.addSubview(scrollView)
        view.addSubview(spinner)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(welcomeView)
        welcomeView.addSubview(welcomeStackView)
        welcomeStackView.addArrangedSubview(loginLabel)
        welcomeStackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(containerView)
        
        containerView.addSubview(contentStackView)
        [segmentedControl,emailLabel,emailTextField, passwordLabel,passwordTextField, actionButton,registerLabel].forEach {
            contentStackView.addArrangedSubview($0)
        }
        
    }
    
    func setupConstraints(){
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        stackView.snp.makeConstraints { make in
            make.height.width.equalTo(scrollView.frameLayoutGuide)
        }
        spinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        welcomeView.snp.makeConstraints { make in
            make.width.equalTo(250)
        }
        welcomeStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
        loginLabel.snp.makeConstraints { make in
            make.height.equalTo(100)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
        containerView.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        contentStackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(25)
        }
        segmentedControl.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        nameTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        actionButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
    }
    
    //MARK: - Actions
    @objc private func segmentChanged() {
        updateForm(for: segmentedControl.selectedSegmentIndex)
    }
    
    @objc private func actionTapped() {
        let isLogin = segmentedControl.selectedSegmentIndex == 0
        if isLogin {
            viewModel.login(email: emailTextField.text ?? "",
                            password: passwordTextField.text ?? "")
        } else {
            viewModel.register(name: nameTextField.text ?? "",
                               email: emailTextField.text ?? "",
                               password: passwordTextField.text ?? "")
        }
    }
    
    @objc private func registerLabelTapped(_ gesture: UITapGestureRecognizer) {
        guard let text = registerLabel.attributedText?.string else { return }
        
        let targetWord = segmentedControl.selectedSegmentIndex == 0 ? "Register" : "Login"
        let nsText = NSString(string: text)
        let range = nsText.range(of: targetWord)
        
        if gesture.didTapAttributedTextInLabel(label: registerLabel, inRange: range) {
            let newIndex = segmentedControl.selectedSegmentIndex == 0 ? 1 : 0
            segmentedControl.selectedSegmentIndex = newIndex
            updateForm(for: newIndex)
        }
    }
    
    //MARK: - Functions
    private func updateForm(for index: Int) {
        contentStackView.arrangedSubviews.forEach {
            if $0 != segmentedControl { $0.removeFromSuperview() }
        }
        
        if index == 0 {
            // Login Mode
            actionButton.setTitle("Login", for: .normal)
            contentStackView.addArrangedSubview(emailLabel)
            contentStackView.addArrangedSubview(emailTextField)
            contentStackView.addArrangedSubview(passwordLabel)
            contentStackView.addArrangedSubview(passwordTextField)
            contentStackView.addArrangedSubview(actionButton)
            contentStackView.addArrangedSubview(registerLabel)
        } else {
            // Register Mode
            actionButton.setTitle("Register", for: .normal)
            contentStackView.addArrangedSubview(nameLabel)
            contentStackView.addArrangedSubview(nameTextField)
            contentStackView.addArrangedSubview(emailLabel)
            contentStackView.addArrangedSubview(emailTextField)
            contentStackView.addArrangedSubview(passwordLabel)
            contentStackView.addArrangedSubview(passwordTextField)
            contentStackView.addArrangedSubview(actionButton)
            contentStackView.addArrangedSubview(registerLabel)
        }
        updateRegisterLabel(for: index)
    }
    
    private func updateRegisterLabel(for index: Int) {
        let attrText = NSMutableAttributedString()
            let baseFont = UIFont.systemFont(ofSize: 14)
            
            if index == 0 {
                attrText.append(NSAttributedString(string: "Don't have an account? ",
                                                   attributes: [.foregroundColor: UIColor.gray.withAlphaComponent(0.7), .font: baseFont]))
                attrText.append(NSAttributedString(string: "Register",
                                                   attributes: [.foregroundColor: UIColor.black, .font: baseFont]))
            } else {
                attrText.append(NSAttributedString(string: "Already have an account? ",
                                                   attributes: [.foregroundColor: UIColor.gray.withAlphaComponent(0.7), .font: baseFont]))
                attrText.append(NSAttributedString(string: "Login",
                                                   attributes: [.foregroundColor: UIColor.black, .font: baseFont]))
            }
            
            registerLabel.attributedText = attrText
            registerLabel.isUserInteractionEnabled = true
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(registerLabelTapped(_:)))
            registerLabel.addGestureRecognizer(tapGesture)
    }
    
    private func bindViewModel() {
        viewModel.onLoadingStateChange = { [weak self] isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self?.spinner.startAnimating()
                    self?.actionButton.isEnabled = false
                    self?.actionButton.alpha = 0.5
                } else {
                    self?.spinner.stopAnimating()
                    self?.actionButton.isEnabled = true
                    self?.actionButton.alpha = 1.0
                }
            }
        }
        
        viewModel.onError = { [weak self] error in
            self?.showAlert(error)
        }
        
        viewModel.onSuccess = { [weak self] user in
            self?.navigateToMain(user: user)
        }
    }
    
    private func navigateToMain(user: UserModel) {
        let tabBar = MainTabBarController(user: user)
        self.navigationController?.pushViewController(tabBar, animated: true)
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}


