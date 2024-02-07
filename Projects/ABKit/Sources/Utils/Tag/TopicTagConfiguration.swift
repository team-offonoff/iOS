//
//  TopicTagConfiguration.swift
//  ABKit
//
//  Created by 박소윤 on 2024/02/06.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit

public struct TopicTagConfiguration {
    
    public init(color: UIColor, title: String) {
        self.color = color
        self.title = title
    }
    
    let color: UIColor
    let title: String
}
