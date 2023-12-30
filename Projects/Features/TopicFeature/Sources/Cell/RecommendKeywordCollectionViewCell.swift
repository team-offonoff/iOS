//
//  RecommendKeywordCollectionViewCell.swift
//  TopicFeatureInterface
//
//  Created by 박소윤 on 2023/12/26.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit

final class RecommendKeywordCollectionViewCell: BaseCollectionViewCell {
    
    private let button: UIButton = {
        var configuration = UIButton.Configuration.bordered()
        configuration.background.backgroundColor = Color.transparent
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 16, bottom: 5, trailing: 16)
        configuration.cornerStyle = .capsule
        configuration.background.strokeWidth = 1
        configuration.background.strokeColor = Color.subNavy2
        return UIButton(configuration: configuration)
    }()
    
    override func hierarchy() {
        baseView.addSubview(button)
    }
    
    override func layout() {
        button.snp.makeConstraints{
            $0.top.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(30)
        }
    }
    
    func fill(_ title: String) {
        let attributedString = NSMutableAttributedString(string: title)
        attributedString.addAttributes([.font: Pretendard.semibold14.font, .foregroundColor: Color.subPurple], range: NSRange(location: 0, length: attributedString.length))
        button.configuration?.attributedTitle = AttributedString(attributedString)
    }
    
    static func size(_ title: String) -> CGSize {
        
        let button: UIButton = {
            
            let attributedString = NSMutableAttributedString(string: title)
            attributedString.addAttributes([.font: Pretendard.semibold14, .foregroundColor: Color.subPurple], range: NSRange(location: 0, length: attributedString.length))
            
            var configuration = UIButton.Configuration.bordered()
            configuration.background.backgroundColor = Color.transparent
//            configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15)
            configuration.cornerStyle = .capsule
            configuration.background.strokeWidth = 1
            configuration.background.strokeColor = Color.subNavy2
            configuration.attributedTitle = AttributedString(attributedString)
            return UIButton(configuration: configuration)
        }()

        return CGSize(width: button.intrinsicContentSize.width+3, height: 30)
    }
}
