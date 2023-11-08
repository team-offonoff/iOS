//
//  TimerInformation.swift
//  FeatureDependency
//
//  Created by 박소윤 on 2023/11/06.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

public struct TimerInfo{
    
    public init(time: Time, isHighlight: Bool) {
        self.time = time
        self.isHighlight = isHighlight
    }
    
    public let time: Time
    public let isHighlight: Bool
}

public struct Time{
    
    public init(hour: Int, minute: Int, second: Int) {
        self.hour = hour
        self.minute = minute
        self.second = second
    }
    
    public let hour: Int
    public let minute: Int
    public let second: Int
}
 
