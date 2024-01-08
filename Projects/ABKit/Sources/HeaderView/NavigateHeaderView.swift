//
//  NavigateHeaderView.swift
//  ABKit
//
//  Created by 박소윤 on 2023/09/28.
//  Copyright © 2023 AB. All rights reserved.
//

import UIKit

public class NavigateHeaderView: HeaderView, Navigatable {
    
    public lazy var popButton: UIButton = {
       let button = UIButton()
        button.setImage(Image.back, for: .normal)
        return button
    }()
    
    public override func hierarchy() {
        super.hierarchy()
        addSubviews([popButton])
    }
    
    public override func layout() {
        super.layout()
        popButton.snp.makeConstraints{
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().offset(20)
            $0.width.height.equalTo(24)
            $0.centerY.equalToSuperview()
        }
    }
}
