//
//  ToastMessageView.swift
//  FeatureDependency
//
//  Created by 박소윤 on 2023/12/10.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit

final class ToastMessageView: BaseView {
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.setTypo(Pretendard.medium15)
        label.textColor = Color.white
        return label
    }()
    
    override func style() {
        backgroundColor = Color.subPurple
    }
    
    public override func hierarchy() {
        addSubview(messageLabel)
    }
    
    public override func layout() {
        self.snp.makeConstraints{
            $0.height.equalTo(80 + (Device.safeAreaInsets?.top ?? 0))
        }
        messageLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(8)
        }
    }
}
