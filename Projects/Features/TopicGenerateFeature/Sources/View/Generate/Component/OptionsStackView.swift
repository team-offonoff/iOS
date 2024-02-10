//
//  OptionsStackView.swift
//  TopicFeature
//
//  Created by 박소윤 on 2024/01/20.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit

final class OptionsStackView: BaseStackView {
    
    let aTextField: OptionTextFieldView = {
        let view = OptionTextFieldView(option: .A)
        view.errorLabel.isHidden = true
        return view
    }()
    let bTextField: OptionTextFieldView = OptionTextFieldView(option: .B)
    
    override func style() {
        axis = .vertical
        spacing = 8
    }
    
    override func hierarchy() {
        addArrangedSubviews([aTextField, bTextField])
    }
}
