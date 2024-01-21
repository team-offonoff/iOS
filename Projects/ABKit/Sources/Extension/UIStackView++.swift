//
//  UIStackView++.swift
//  ABKit
//
//  Created by 박소윤 on 2023/09/26.
//  Copyright © 2023 AB. All rights reserved.
//

import UIKit

public extension UIStackView {
    
    func addArrangedSubviews(_ views:[UIView]) {
        views.forEach{
            addArrangedSubview($0)
        }
    }
    
    convenience init(axis: NSLayoutConstraint.Axis, spacing: CGFloat, alignment: Alignment){
        self.init(frame: .zero)
        self.axis = axis
        self.spacing = spacing
        self.alignment = alignment
    }
    
    convenience init(axis: NSLayoutConstraint.Axis, spacing: CGFloat){
        self.init(frame: .zero)
        self.axis = axis
        self.spacing = spacing
    }
}
