//
//  ABTextFieldViewConfiguration.swift
//  ABKit
//
//  Created by 박소윤 on 2024/01/06.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit

public struct ABTextFieldViewConfiguration {
    
    public init(backgroundColor: UIColor, textColor: UIColor, font: UIFont, countColor: UIColor, countFont: UIFont, errorColor: UIColor, errorFont: UIFont) {
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.font = font
        self.countColor = countColor
        self.countFont = countFont
        self.errorColor = errorColor
        self.errorFont = errorFont
    }
    
    public let backgroundColor: UIColor
    public let textColor: UIColor
    public let font: UIFont
    public let countColor: UIColor
    public let countFont: UIFont
    public let errorColor: UIColor
    public let errorFont: UIFont
}

public struct ABTextFieldViewStateConfiguration {
    
    public init(strokeWidth: CGFloat?, strokeColor: UIColor?, isCountLabelHidden: Bool, isErrorLabelHidden: Bool) {
        self.strokeWidth = strokeWidth
        self.strokeColor = strokeColor
        self.isCountLabelHidden = isCountLabelHidden
        self.isErrorLabelHidden = isErrorLabelHidden
    }
    
    public let strokeWidth: CGFloat?
    public let strokeColor: UIColor?
    public let isCountLabelHidden: Bool
    public let isErrorLabelHidden: Bool
}

//MARK: Default Configuration

public let defaultABTextFieldViewConfiguration: ABTextFieldViewConfiguration = ABTextFieldViewConfiguration(
    backgroundColor: Color.subNavy2.withAlphaComponent(0.4),
    textColor: Color.white,
    font: Pretendard.semibold14.font,
    countColor: Color.subPurple.withAlphaComponent(0.6),
    countFont: Pretendard.semibold14.font,
    errorColor: Color.subPurple2,
    errorFont: Pretendard.semibold13.font
)

public let abTextFieldViewEmptyStateConfiguration: ABTextFieldViewStateConfiguration = ABTextFieldViewStateConfiguration(
    strokeWidth: 0,
    strokeColor: nil,
    isCountLabelHidden: false,
    isErrorLabelHidden: true
)

public let abTextFieldViewEditingStateConfiguration: ABTextFieldViewStateConfiguration = ABTextFieldViewStateConfiguration(
    strokeWidth: nil,
    strokeColor: nil,
    isCountLabelHidden: false,
    isErrorLabelHidden: true
)

public let abTextFieldViewErrorStateConfiguration: ABTextFieldViewStateConfiguration = ABTextFieldViewStateConfiguration(
    strokeWidth: 1,
    strokeColor: Color.subPurple2,
    isCountLabelHidden: false,
    isErrorLabelHidden: false
)
