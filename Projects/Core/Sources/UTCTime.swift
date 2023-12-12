//
//  UTCTime.swift
//  Core
//
//  Created by 박소윤 on 2023/12/12.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

public struct UTCTime {
    
    public static var current: Int {
        Int(Date.now.timeIntervalSince1970)
    }
    
}
