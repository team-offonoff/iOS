//
//  RadioButtonCell.swift
//  ABKit
//
//  Created by 박소윤 on 2023/11/16.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit

public protocol RadioButtonCell where Self: UIView {
    var titleLabel: UILabel { get set }
    func select()
    func deselect()
}
