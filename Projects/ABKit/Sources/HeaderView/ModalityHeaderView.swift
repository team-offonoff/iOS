//
//  ModalityHeaderView.swift
//  ABKit
//
//  Created by 박소윤 on 2023/12/25.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit

public class ModalityHeaderView: HeaderView, ModalDismissable {
    
    public lazy var dismissButton: UIButton = {
       let button = UIButton()
        button.setImage(Image.exit, for: .normal)
        return button
    }()
    
    public override func hierarchy() {
        super.hierarchy()
        addSubviews([dismissButton])
    }
    
    public override func layout() {
        super.layout()
        dismissButton.snp.makeConstraints{
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().offset(20)
            $0.width.height.equalTo(24)
            $0.centerY.equalToSuperview()
        }
    }
}
