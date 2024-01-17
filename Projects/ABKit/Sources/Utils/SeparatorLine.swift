//
//  SeparatorLine.swift
//  ABKit
//
//  Created by 박소윤 on 2024/01/16.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit

public final class SeparatorLine: UIView {
    
    public init(color: UIColor, height: CGFloat) {
        super.init(frame: .zero)
        backgroundColor = color
        snp.makeConstraints{
            $0.height.equalTo(height)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
