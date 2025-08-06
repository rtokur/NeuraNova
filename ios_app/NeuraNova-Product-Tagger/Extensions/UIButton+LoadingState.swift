//
//  UIButton+LoadingState.swift
//  NeuraNova-Product-Tagger
//
//  Created by Rumeysa Tokur on 6.08.2025.
//

import UIKit

extension UIButton {
    private struct AssociatedKeys {
        static var activityIndicator = "UIButton.ActivityIndicator"
        static var originalTitle = "UIButton.OriginalTitle"
    }
    
    private var activityIndicator: UIActivityIndicatorView? {
        get { objc_getAssociatedObject(self, &AssociatedKeys.activityIndicator) as? UIActivityIndicatorView }
        set { objc_setAssociatedObject(self, &AssociatedKeys.activityIndicator, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    private var originalTitle: String? {
        get { objc_getAssociatedObject(self, &AssociatedKeys.originalTitle) as? String }
        set { objc_setAssociatedObject(self, &AssociatedKeys.originalTitle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    func showLoading(_ loading: Bool) {
        if loading {
            originalTitle = self.title(for: .normal)
            
            self.setTitle("", for: .normal)
            self.isEnabled = false
            
            if activityIndicator == nil {
                let indicator = UIActivityIndicatorView(style: .medium)
                indicator.color = self.titleColor(for: .normal)
                indicator.hidesWhenStopped = true
                self.addSubview(indicator)
                indicator.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                    indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
                ])
                activityIndicator = indicator
            }
            activityIndicator?.startAnimating()
        } else {
            activityIndicator?.stopAnimating()
            self.setTitle(originalTitle, for: .normal)
            self.isEnabled = true
        }
    }
}
