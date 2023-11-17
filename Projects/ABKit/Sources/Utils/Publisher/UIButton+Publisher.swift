//
//  UIButton+Publisher.swift
//  ABKit
//
//  Created by 박소윤 on 2023/11/12.
//  Copyright © 2023 AB. All rights reserved.
//

import UIKit
import Combine

public extension UIButton {
    var tapPublisher: AnyPublisher<Void, Never> {
        controlPublisher(for: .touchUpInside)
            .map { _ in }
            .eraseToAnyPublisher()
    }
}
