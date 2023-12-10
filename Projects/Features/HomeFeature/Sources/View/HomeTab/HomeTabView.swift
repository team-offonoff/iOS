//
//  HomeTabView.swift
//  HomeFeature
//
//  Created by 박소윤 on 2023/10/03.
//  Copyright © 2023 AB. All rights reserved.
//

import UIKit
import ABKit

final class HomeTabView: BaseView {
    
    let scrollFrame: ScrollFrame = ScrollFrame()
    
    override func hierarchy() {
        addSubviews([scrollFrame])
    }
    
    override func layout() {
        scrollFrame.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
