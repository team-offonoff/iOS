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
    
    public init(insets: UIEdgeInsets? = nil){
        if let insets = insets {
            self.insets = insets
        }
        else {
            self.insets = UIEdgeInsets(top: 14, left: 16, bottom: 14, right: 15)
        }
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let insets: UIEdgeInsets
    private let clearButtonOffset: CGFloat = 5
    private let clearButtonLeftPadding: CGFloat = 5
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: insets)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: insets)
    }
    
    // clearButton의 위치와 크기를 고려해 inset을 삽입
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        let clearButtonWidth = clearButtonRect(forBounds: bounds).width
        let editingInsets = UIEdgeInsets(
            top: insets.top,
            left: insets.left,
            bottom: insets.bottom,
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
    
    public override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rightViewRect = super.rightViewRect(forBounds: bounds)
        rightViewRect.origin.x -= 12
        return rightViewRect
    }
}
