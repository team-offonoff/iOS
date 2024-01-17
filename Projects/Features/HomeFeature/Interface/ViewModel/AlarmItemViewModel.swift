//
//  AlarmItemViewModel.swift
//  HomeFeatureInterface
//
//  Created by 박소윤 on 2024/01/17.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import Domain

public struct AlarmItemViewModel {
    
    public init(
        isNew: Bool,
        type: Alarm.Case,
        title: String,
        subtitle: String
    ) {
        self.isNew = isNew
        self.type = type
        self.title = title
        self.subtitle = subtitle
    }
    
    public var isNew: Bool
    public let type: Alarm.Case
    public let title: String
    public let subtitle: String
    public var time: String {
        ""
    }
    
}
