//
//  TopicTagView.swift
//  ABKit
//
//  Created by 박소윤 on 2024/02/06.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit

public final class TopicTagView: BaseStackView {
    
    private let roundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 14/2
        view.snp.makeConstraints{
            $0.width.height.equalTo(14)
        }
        return view
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.setTypo(Pretendard.semibold13, setLineSpacing: true)
        return label
    }()
    
    public override func style() {
        
        layer.cornerRadius = 22/2
        axis = .horizontal
        spacing = 10
        alignment = .center
        padding()
        
        
        func padding() {
            layoutMargins = UIEdgeInsets(top: 2, left: 10, bottom: 2, right: 10)
            isLayoutMarginsRelativeArrangement = true
        }
    }
    
    public override func hierarchy() {
        addArrangedSubviews([roundView, titleLabel])
        self.snp.makeConstraints{
            $0.height.equalTo(22)
        }
    }
    
    public func fill(_ configuration: TopicTagConfiguration) {
        backgroundColor = configuration.color.withAlphaComponent(0.2)
        roundView.backgroundColor = configuration.color
        titleLabel.textColor = configuration.color
        titleLabel.text = configuration.title
    }
    
}
