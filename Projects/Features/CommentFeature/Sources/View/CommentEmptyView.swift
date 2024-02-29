//
//  CommentEmptyView.swift
//  CommentFeature
//
//  Created by 박소윤 on 2024/02/27.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit

final class CommentEmptyView: BaseView {
    
    private let explainLabel: UILabel = {
       let label = UILabel()
        label.text = "가장 먼저 댓글을 작성해 보세요!"
        label.textColor = Color.black.withAlphaComponent(0.8)
        label.setTypo(Pretendard.regular16)
        return label
    }()
    
    override func hierarchy() {
        addSubview(explainLabel)
    }
    
    override func layout() {
        explainLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}
