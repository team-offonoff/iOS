//
//  UITextField+Publisher.swift
//  ABKit
//
//  Created by 박소윤 on 2023/11/12.
//  Copyright © 2023 AB. All rights reserved.
//

import Combine
import UIKit

public extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        controlPublisher(for: .editingChanged)
            .map{ $0 as! UITextField }
            .map { $0.text ?? "" }
            .eraseToAnyPublisher()
    }
}
