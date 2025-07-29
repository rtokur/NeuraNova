//
//  ViewController.swift
//  NeuraNova-Product-Tagger
//
//  Created by Rumeysa Tokur on 29.07.2025.
//

import UIKit

class MainTabBarController: UITabBarController{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        
        let createVC = UINavigationController(rootViewController: CreateViewController())
        createVC.tabBarItem = UITabBarItem(title: "Create", image: UIImage(systemName: "plus.circle"), tag: 1)
        
        let historyVC = UINavigationController(rootViewController: HistoryViewController())
        historyVC.tabBarItem = UITabBarItem(title: "History", image: UIImage(systemName: "clock.arrow.circlepath"), tag: 2)
        
        viewControllers = [homeVC, createVC, historyVC]
        
        setupTabBarAppearance()
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        tabBar.tintColor = .white
        
        tabBar.unselectedItemTintColor = UIColor.white.withAlphaComponent(0.5)
        
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }
}
