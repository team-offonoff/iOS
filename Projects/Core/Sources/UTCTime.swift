//
//  UTCTime.swift
//  Core
//
//  Created by 박소윤 on 2023/12/12.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

public struct UTCTime {
    
    public static let dayUnit = 60*60*24
    public static let hourUnit = 60*60
    public static let minuteUnit = 60
    
    public static var current: Int {
        Int(Date.now.timeIntervalSince1970)
    }
    
    public static func day(diff: Int) -> Int {
        diff / UTCTime.dayUnit
    }

    public static func hour(diff: Int) -> Int {
        diff % UTCTime.dayUnit / UTCTime.hourUnit
    }

    public static func minute(diff: Int) -> Int {
        diff % UTCTime.dayUnit % UTCTime.hourUnit / UTCTime.minuteUnit
    }
}
