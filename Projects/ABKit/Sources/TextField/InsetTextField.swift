//
//  InsetTextField.swift
//  ABKit
//
//  Created by 박소윤 on 2023/12/22.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit

public class InsetTextField: UITextField {

    private let commonInsets = UIEdgeInsets(top: 14, left: 16, bottom: 14, right: 15)
    private let clearButtonOffset: CGFloat = 5
    private let clearButtonLeftPadding: CGFloat = 5
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: commonInsets)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: commonInsets)
    }
    
    // clearButton의 위치와 크기를 고려해 inset을 삽입
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        let clearButtonWidth = clearButtonRect(forBounds: bounds).width
        let editingInsets = UIEdgeInsets(
            top: commonInsets.top,
            left: commonInsets.left,
            bottom: commonInsets.bottom,
            right: clearButtonWidth + clearButtonOffset + clearButtonLeftPadding
        )
        
        return bounds.inset(by: editingInsets)
    }
    
    // clearButtonOffset만큼 x축 이동
    public override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        var clearButtonRect = super.clearButtonRect(forBounds: bounds)
        clearButtonRect.origin.x -= clearButtonOffset;
        return clearButtonRect
    }
}
