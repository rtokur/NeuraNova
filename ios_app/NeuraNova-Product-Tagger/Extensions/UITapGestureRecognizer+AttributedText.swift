//
//  UITapGestureRecognizer+AttributedText.swift
//  NeuraNova-Product-Tagger
//
//  Created by Rumeysa Tokur on 31.07.2025.
//

import UIKit

extension UITapGestureRecognizer {
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        guard let attributedText = label.attributedText else { return false }
        
        let mutableAttrString = NSMutableAttributedString(attributedString: attributedText)
        mutableAttrString.addAttributes([.font: label.font ?? UIFont.systemFont(ofSize: 14)],
                                        range: NSRange(location: 0, length: attributedText.length))
        
        let textStorage = NSTextStorage(attributedString: mutableAttrString)
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: label.bounds.size)
        
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        let locationOfTouch = self.location(in: label)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouch,
                                                            in: textContainer,
                                                            fractionOfDistanceBetweenInsertionPoints: nil)
        
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}
