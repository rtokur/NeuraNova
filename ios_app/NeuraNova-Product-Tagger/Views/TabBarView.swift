//
//  TabBarView.swift
//  NeuraNova-Product-Tagger
//
//  Created by Rumeysa Tokur on 5.08.2025.
//

import UIKit

protocol TabBarControllerProtocol: AnyObject {
    func didTapTabBarButton(_ index: Int)
}

class TabBarView: UIView {
    private var buttons: [UIButton] = []
    
    weak var tabBarController: TabBarControllerProtocol?
    
    private let selectedBackgroundLayer = CALayer()
    private(set) var selectedIndex = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Tabbar background rengi
        backgroundColor = UIColor(named: "484849")!
        layer.cornerRadius = 30
        layer.masksToBounds = true
        
        setupButtons()
        setupMovingLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        calculateButtonFrames()
        selectedBackgroundLayer.frame = buttons[selectedIndex].frame
        selectedBackgroundLayer.cornerRadius = selectedBackgroundLayer.bounds.height / 2
    }
    
    // MARK: - Setup Buttons
    private func setupButtons() {
        buttons = TabBarButton.allCases.map { buttonType in
            let btn = makeButton(model: buttonType)
            btn.tag = buttonType.rawValue
            if buttonType.rawValue == 0 { btn.isSelected = true }
            addSubview(btn)
            btn.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            return btn
        }
    }
    
    private func makeButton(model: TabBarButton) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(model.title, for: .normal)
        btn.setImage(model.icon, for: .normal)
        btn.tintColor = .white
        btn.setTitleColor(.white, for: .normal)
        
        btn.setTitleColor(.black, for: .selected)
        btn.setImage(model.icon?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .selected)
        
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        btn.backgroundColor = .clear
        btn.clipsToBounds = true

        btn.contentHorizontalAlignment = .center
        btn.imageView?.contentMode = .scaleAspectFit
        btn.imageEdgeInsets = UIEdgeInsets(top: -4, left: 0, bottom: 0, right: 0)
        return btn
    }
    
    // MARK: - Layout Calculation
    private func calculateButtonFrames() {
        let totalWidth = bounds.width
        let buttonCount = buttons.count
        
        let selectedButtonWidth: CGFloat = 100
        let compactButtonWidth: CGFloat = 50
        

        let compactTotalWidth = compactButtonWidth * CGFloat(buttonCount - 1)
        
        let totalSpacing = totalWidth - selectedButtonWidth - compactTotalWidth
        let spacing = totalSpacing / CGFloat(buttonCount + 1)
        
        var xOffset = spacing
        
        for (index, button) in buttons.enumerated() {
            let isSelected = index == selectedIndex
            let width = isSelected ? selectedButtonWidth : compactButtonWidth
            let height = bounds.height - 10
            
            button.frame = CGRect(x: xOffset, y: 5, width: width, height: height)
            button.layer.cornerRadius = height / 2
            
            button.setTitle(isSelected ? TabBarButton.allCases[index].title : "", for: .normal)
            
            xOffset += width + spacing
        }
    }

    func setSelectedIndex(_ index: Int) {
        buttons[selectedIndex].isSelected = false
        
        buttons[index].isSelected = true
        selectedIndex = index
        
        UIView.animate(withDuration: 0.25) {
            self.selectedBackgroundLayer.frame = self.buttons[index].frame
            self.layoutIfNeeded()
        }
        
        calculateButtonFrames()
    }
    
    // MARK: - Background Layer
    private func setupMovingLayer() {
        selectedBackgroundLayer.backgroundColor = UIColor.white.cgColor
        layer.insertSublayer(selectedBackgroundLayer, at: 0)
    }
    
    // MARK: - Actions
    @objc private func buttonTapped(_ sender: UIButton) {
        buttons[selectedIndex].isSelected = false
        sender.isSelected = true
        selectedIndex = sender.tag
        tabBarController?.didTapTabBarButton(selectedIndex)
        
        UIView.animate(withDuration: 0.25) {
            self.selectedBackgroundLayer.frame = sender.frame
            self.layoutIfNeeded()
        }
    }
}

enum TabBarButton: Int, CaseIterable {
    case home
    case create
    case history
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .create: return "Create"
        case .history: return "History"
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .home: return UIImage(systemName: "house")!
        case .create: return UIImage(systemName: "plus")!
        case .history: return UIImage(systemName: "clock")!
        }
    }
}
