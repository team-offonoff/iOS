//
//  PaddingLabel.swift
//  ABKit
//
//  Created by 박소윤 on 2023/11/28.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit

open class PaddingLabel: UILabel {
    
    public convenience init(topBottom: CGFloat, leftRight: CGFloat) {
        self.init(top: topBottom, bottom: topBottom, left: leftRight, right: leftRight)
    }
    
    public init(top: CGFloat, bottom: CGFloat, left: CGFloat, right: CGFloat) {
        self.topInset = top
        self.bottomInset = bottom
        self.leftInset = left
        self.rightInset = right
        super.init(frame: .zero)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let topInset: CGFloat
    private let bottomInset: CGFloat
    private let leftInset: CGFloat
    private let rightInset: CGFloat
        
    public override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    public override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset, height: size.height + topInset + bottomInset)
    }
}
