//
//  SceneDelegate.swift
//  NeuraNova-Product-Tagger
//
//  Created by Rumeysa Tokur on 29.07.2025.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let db = Firestore.firestore()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        if let currentUser = Auth.auth().currentUser {
            db.collection("users").document(currentUser.uid).getDocument { [weak self] doc, error in
                if let data = doc?.data(), let user = UserModel(data: data) {
                    let navigationController = UINavigationController(rootViewController: MainTabBarController(user: user))
                    navigationController.setNavigationBarHidden(true, animated: true)
                    self?.window?.rootViewController = navigationController
                } else {
                    let navigationController = UINavigationController(rootViewController: OnBoardingViewController())
                    navigationController.setNavigationBarHidden(true, animated: true)
                    self?.window?.rootViewController = navigationController
                }
                self?.window?.makeKeyAndVisible()
            }
        } else {
            let navigationController = UINavigationController(rootViewController: OnBoardingViewController())
            navigationController.setNavigationBarHidden(true, animated: true)
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

