//
//  KeywordItemCell.swift
//  SideBFeature
//
//  Created by 박소윤 on 2024/02/12.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit

final class KeywordItemCell: BaseCollectionViewCell {
    
    var isCellSelected: Bool = false {
        didSet {
            if isCellSelected {
                titleLabel.textColor = Color.subPurple
                titleLabel.layer.borderColor = Color.subPurple.withAlphaComponent(0.6).cgColor
                titleLabel.setTypo(Pretendard.semibold14)
            }
            else {
                titleLabel.textColor = Color.white60
                titleLabel.layer.borderColor = Color.white20.cgColor
                titleLabel.setTypo(Pretendard.regular14)
            }
        }
    }
    
    static func itemSize(title: String) -> CGSize {
        let highlightLabel: PaddingLabel = {
            let label = PaddingLabel(topBottom: 6, leftRight: 14)
            label.text = title
            label.setTypo(Pretendard.semibold14)
            label.layer.borderWidth = 1
            return label
        }()
        let hightlightWidth = highlightLabel.intrinsicContentSize.width
        
        let normalLabel: PaddingLabel = {
            let label = PaddingLabel(topBottom: 6, leftRight: 14)
            label.text = title
            label.setTypo(Pretendard.regular14)
            label.layer.borderWidth = 1
            return label
        }()
        let normalWidth = normalLabel.intrinsicContentSize.width
        return .init(width: max(hightlightWidth, normalWidth), height: 32)
    }
    
    private let titleLabel: PaddingLabel = {
        let label = PaddingLabel(topBottom: 6, leftRight: 14)
        label.layer.borderWidth = 1
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 32/2
        return label
    }()
    
    override func hierarchy() {
        addSubview(titleLabel)
    }
    
    override func layout() {
        titleLabel.snp.makeConstraints{
            $0.leading.trailing.top.bottom.equalToSuperview()
            $0.height.equalTo(32)
        }
    }
    
    func fill(title: String) {
        titleLabel.text = title
    }
}
