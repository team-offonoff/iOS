//
//  UITextView+Publisher.swift
//  ABKit
//
//  Created by 박소윤 on 2023/12/30.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit
import Combine

public extension UITextView {
    
    func publisher(for event: UIControl.Event) -> AnyPublisher<String, Never> {

        return NotificationCenter
            .default
            .publisher(for: notificationName(), object: self)
            .compactMap{ $0.object as? UITextView}
            .map{ $0.text ?? "" }
            .eraseToAnyPublisher()
        
        func notificationName() -> NSNotification.Name {
            switch event {
            case .editingDidBegin:
                return UITextView.textDidBeginEditingNotification
            case .editingDidEnd:
                return UITextView.textDidEndEditingNotification
            case .editingChanged:
                return UITextView.textDidChangeNotification
            default:
                fatalError()
            }
        }
    }
}
