//
//  NSMutableAttributedString++.swift
//  ABKit
//
//  Created by 박소윤 on 2023/09/26.
//  Copyright © 2023 AB. All rights reserved.
//

import UIKit

extension NSMutableAttributedString{
    
    @discardableResult
    func setLineHeight(_ lineSpacing: CGFloat, fontLineHeight: CGFloat) -> Self{
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.maximumLineHeight = lineSpacing
        paragraphStyle.minimumLineHeight = lineSpacing
        
        addAttributes(
            [.paragraphStyle: paragraphStyle,
             .baselineOffset: (lineSpacing - fontLineHeight) / 4]
            , range: NSRange(location: 0, length: length)
        )
        return self
    }
    
    @discardableResult
    func setKern(_ kern: CGFloat) -> Self{
        addAttributes(
                [.kern: kern],
                range: NSRange(location: 0, length: length)
            )
        return self
    }
    
    func setFont(_ font: UIFont) -> Self {
        addAttributes(
                [.font: font],
                range: NSRange(location: 0, length: length)
            )
        return self
    }
}
