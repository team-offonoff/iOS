//
//  UILabel++.swift
//  ABKit
//
//  Created by 박소윤 on 2023/09/26.
//  Copyright © 2023 AB. All rights reserved.
//

import UIKit

public extension UILabel{
    
    private var mutableAttributedString: NSMutableAttributedString{
        if text == nil { text = " " }
        guard let text = self.text, text.count > 0, let attributedText = self.attributedText else {
            return NSMutableAttributedString()
        }
        return NSMutableAttributedString(attributedString: attributedText)
    }
    
    func setTypo(_ font: UIFont){
        self.font = font
    }
    
    /*
    func setTypo(_ font: UIFont, kern: CGFloat){
        attributedText = mutableAttributedString
            .setFont(font)
            .setKern(kern)
    }
     */
    
    func setTypo(_ font: UIFont, lineSpacing: CGFloat){
        attributedText = mutableAttributedString
            .setFont(font)
            .setLineHeight(lineSpacing, fontLineHeight: font.lineHeight)
    }
    
    /*
    func setTypo(_ font: UIFont, lineSpacing: CGFloat, kern: CGFloat){
        attributedText = mutableAttributedString
            .setFont(font)
            .setLineHeight(lineSpacing, fontLineHeight: font.lineHeight)
            .setKern(kern)
    }
     */
    
    func setTypo(_ typo: TypoCase) {
        let font = Typo.font(type: typo)
        if let lineHeight = typo.lineHeight {
            setTypo(font, lineSpacing: lineHeight)
        } else {
            setTypo(font)
        }
    }
}
