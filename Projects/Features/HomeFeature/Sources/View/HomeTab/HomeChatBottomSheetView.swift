//
//  HomeChatBottomSheetView.swift
//  HomeFeature
//
//  Created by 박소윤 on 2023/09/27.
//  Copyright © 2023 AB. All rights reserved.
//

import UIKit
import ABKit

final class HomeChatBottomSheetView: BaseView {
    
    let headerFrame: ChatHeaderFrame = ChatHeaderFrame()
    let chatFrame: ChatFrame = ChatFrame()
    
    override func style() {
        layer.cornerRadius = 20
        layer.masksToBounds = true
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        backgroundColor = Color.subNavy2
    }
    
    override func hierarchy() {
        addSubviews([headerFrame, chatFrame])
    }
    
    override func layout() {
        headerFrame.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
        }
        chatFrame.snp.makeConstraints{
            $0.top.equalTo(headerFrame.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
