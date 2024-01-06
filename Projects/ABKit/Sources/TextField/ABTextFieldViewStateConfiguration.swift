//
//  ABTextFieldViewConfiguration.swift
//  ABKit
//
//  Created by 박소윤 on 2024/01/06.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit

public protocol ABTextFieldViewConfiguration {
    var backgroundColor: UIColor { get }
    var textColor: UIColor { get }
    var countColor: UIColor { get }
    var countFont: UIFont { get }
    var errorColor: UIColor { get }
    var errorFont: UIFont { get }
}

public protocol ABTextFieldViewStateConfiguration {
    var strokeWidth: CGFloat? { get }
    var strokeColor: UIColor? { get }
    var isCountLabelHidden: Bool { get }
    var isErrorLabelHidden: Bool { get }
}

//MARK: Default Configuration

public struct DefaultABTextFieldViewConfiguration: ABTextFieldViewConfiguration {
    public let backgroundColor: UIColor = Color.subNavy2.withAlphaComponent(0.4)
    public let textColor: UIColor = Color.white
    public let countColor: UIColor = Color.subPurple.withAlphaComponent(0.6)
    public let countFont: UIFont = Pretendard.semibold14.font
    public let errorColor: UIColor = Color.subPurple2
    public let errorFont: UIFont = Pretendard.semibold13.font
}

public struct ABTextFieldViewEmptyStateConfiguration: ABTextFieldViewStateConfiguration {
    public let strokeWidth: CGFloat? = 0
    public let strokeColor: UIColor? = nil
    public let isCountLabelHidden: Bool = false
    public let isErrorLabelHidden: Bool = true
}

public struct ABTextFieldViewEditingStateConfiguration: ABTextFieldViewStateConfiguration {
    public let strokeWidth: CGFloat? = nil
    public let strokeColor: UIColor? = nil
    public let isCountLabelHidden: Bool = false
    public let isErrorLabelHidden: Bool = true
}

public struct ABTextFieldViewErrorStateConfiguration: ABTextFieldViewStateConfiguration {
    public let strokeWidth: CGFloat? = 1
    public let strokeColor: UIColor? = Color.subPurple2
    public let isCountLabelHidden: Bool = false
    public let isErrorLabelHidden: Bool = false
}
