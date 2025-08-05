//
//  ViewController.swift
//  NeuraNova-Product-Tagger
//
//  Created by Rumeysa Tokur on 29.07.2025.
//

import UIKit

class MainTabBarController: UITabBarController, TabBarControllerProtocol{
    private let currentUser: UserModel
    private let tabbarView = TabBarView()
    
    init(user: UserModel) {
        self.currentUser = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tabbarView.tabBarController = self
        tabBar.isHidden = true
        
        viewControllers = TabBarButton.allCases.map { generateViewController($0) }
        
        view.addSubview(tabbarView)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let height: CGFloat = 60
            let buttonCount = CGFloat(TabBarButton.allCases.count)
            let selectedButtonWidth: CGFloat = 80
            let compactButtonWidth: CGFloat = 50
            let spacing: CGFloat = 12
            
            // Total width hesabı
            let totalWidth = selectedButtonWidth + (compactButtonWidth * (buttonCount - 1)) + (spacing * (buttonCount + 1))
            
            tabbarView.frame = CGRect(
                x: (view.bounds.width - totalWidth) / 2,
                y: view.bounds.height - height - view.safeAreaInsets.bottom - 10,
                width: totalWidth,
                height: height
            )
    }
    //MARK: - Protocol Method
    func didTapTabBarButton(_ index: Int) {
        selectedIndex = index
    }
    
    
    func setTabBar(hidden: Bool, animated: Bool = true) {
        let height = tabbarView.frame.height + 20
        let transform = hidden ? CGAffineTransform(translationX: 0, y: height) : .identity
        
        UIView.animate(withDuration: animated ? 0.3 : 0,
                       delay: 0,
                       options: [.curveEaseInOut],
                       animations: {
            self.tabbarView.transform = transform
            self.tabbarView.alpha = hidden ? 0 : 1
        })
    }
    //MARK: - Helper
    private func generateViewController(_ button: TabBarButton) -> UIViewController {
        switch button {
        case .home:
            return HomeViewController(user: currentUser)
        case .create:
            return CreateViewController()
        case .history:
            return HistoryViewController()
        }
    }
}
