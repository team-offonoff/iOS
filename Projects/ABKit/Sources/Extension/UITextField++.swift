//
//  UITextField++.swift
//  ABKit
//
//  Created by 박소윤 on 2024/01/06.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    public func customPlaceholder(color: UIColor = Color.subPurple.withAlphaComponent(0.6), font: UIFont) {
        let attributedPlaceholder = NSMutableAttributedString(string: placeholder ?? "")
        attributedPlaceholder.addAttributes([
            .font: font,
            .foregroundColor: color
        ], range: NSRange(location: 0, length: placeholder?.count ?? 0))
        self.attributedPlaceholder = NSAttributedString(attributedString: attributedPlaceholder)
    }
}
