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
    
    func publisher(for event: UIControl.Event) -> AnyPublisher<String, Never> {
        controlPublisher(for: event)
            .map{ $0 as! UITextField }
            .map { $0.text ?? "" }
            .eraseToAnyPublisher()
    }
}
