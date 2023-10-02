//
//  TypoCase.swift
//  ABKit
//
//  Created by 박소윤 on 2023/09/26.
//  Copyright © 2023 AB. All rights reserved.
//

import UIKit

public protocol TypoCase{
    var font: UIFont { get }
    var lineHeight: CGFloat? { get }
}
