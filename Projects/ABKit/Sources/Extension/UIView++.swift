//
//  UIView++.swift
//  ABKit
//
//  Created by 박소윤 on 2023/09/26.
//  Copyright © 2023 AB. All rights reserved.
//

import UIKit

public extension UIView {
    func addSubviews(_ views:[UIView]) {
        views.forEach{
            addSubview($0)
        }
    }
}
