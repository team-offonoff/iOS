//
//  ButtonFrame.swift
//  HomeFeature
//
//  Created by 박소윤 on 2023/10/07.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

import UIKit
import ABKit

extension HomeTabView.ScrollFrame {
    
    final class ButtonFrame: BaseView {
        
        lazy var nextButton: UIButton = {
            let button = UIButton()
            button.setImage(Image.homeArrow, for: .normal)
            return button
        }()
        
        lazy var previousButton: UIButton = {
            let button = UIButton()
            button.setImage(Image.homeArrow.withHorizontallyFlippedOrientation(), for: .normal)
            return button
        }()
        
        override func hierarchy() {
            addSubviews([previousButton, nextButton])
        }
        
        override func layout() {
            nextButton.snp.makeConstraints{
                $0.trailing.equalToSuperview().inset(12)
                $0.top.bottom.equalToSuperview()
                $0.width.height.equalTo(40)
            }
            previousButton.snp.makeConstraints{
                $0.leading.equalToSuperview().inset(12)
                $0.top.bottom.equalToSuperview()
                $0.width.height.equalTo(40)
            }
        }
    }
}
