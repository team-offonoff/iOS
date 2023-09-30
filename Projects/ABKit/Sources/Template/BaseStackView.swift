//
//  BaseStackView.swift
//  ABKit
//
//  Created by 박소윤 on 2023/09/27.
//  Copyright © 2023 AB. All rights reserved.
//

import UIKit

open class BaseStackView: UIStackView {
    
    public init(axis: NSLayoutConstraint.Axis, spacing: CGFloat){
        super.init(frame: .zero)
        self.axis = axis
        self.spacing = spacing
        style()
        hierarchy()
    }
    
    public required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func style() { }
    
    open func hierarchy() { }
}
