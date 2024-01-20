//
//  ABTextFieldViewDelegate.swift
//  ABKit
//
//  Created by 박소윤 on 2024/01/06.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation

public protocol ABTextFieldViewDelegate: AnyObject {
    func configuration(_ textFieldView: ABTextFieldView) -> ABTextFieldViewConfiguration
    func configuration(_ textFieldView: ABTextFieldView, of state: ABTextFieldView.State) -> ABTextFieldViewStateConfiguration
}

extension ABTextFieldViewDelegate {
    
    public func configuration(_ textFieldView: ABTextFieldView) -> ABTextFieldViewConfiguration {
        defaultABTextFieldViewConfiguration
    }
    
    public func configuration(_ textFieldView: ABTextFieldView, of state: ABTextFieldView.State) -> ABTextFieldViewStateConfiguration {
        switch state {
        case .empty:        return abTextFieldViewEmptyStateConfiguration
        case .editing:      return abTextFieldViewEditingStateConfiguration
        case .error:        return abTextFieldViewErrorStateConfiguration
        }
    }
}
