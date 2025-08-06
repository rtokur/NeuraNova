//
//  UIViewController+GradientBackground.swift
//  NeuraNova-Product-Tagger
//
//  Created by Rumeysa Tokur on 1.08.2025.
//

import UIKit

extension UIViewController {
    func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.black.withAlphaComponent(0.9).cgColor, UIColor.black.withAlphaComponent(0.8).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    func showSnackbar(message: String) {
        let snackbarHeight: CGFloat = 50
        let snackbar = UIView(frame: CGRect(x: 20, y: view.frame.height, width: view.frame.width - 40, height: snackbarHeight))
        snackbar.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        snackbar.layer.cornerRadius = 12
        snackbar.clipsToBounds = true
        
        let label = UILabel(frame: CGRect(x: 16, y: 0, width: snackbar.frame.width - 32, height: snackbarHeight))
        label.text = message
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .medium)
        
        snackbar.addSubview(label)
        view.addSubview(snackbar)
        
        UIView.animate(withDuration: 0.3, animations: {
            snackbar.frame.origin.y -= snackbarHeight + 40
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 2, options: [], animations: {
                snackbar.frame.origin.y += snackbarHeight + 40
            }, completion: { _ in
                snackbar.removeFromSuperview()
            })
        }
    }
    
}
