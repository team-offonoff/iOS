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
//        button.setImage(Image.popArrow, for: .normal)
        return button
    }()
    
    public override func hierarchy() {
        super.hierarchy()
        addSubviews([popButton])
    }
    
    public override func layout() {
        super.layout()
//        popButton.snp.makeConstraints{
//
//        }
    }
}
