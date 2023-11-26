//
//  JoinStatus.swift
//  Core
//
//  Created by 박소윤 on 2023/11/26.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

public enum JoinStatus: String {
    case empty = "EMPTY"
    case authRegistered = "AUTH_REGISTERED"
    case personalRegistered = "PERSONAL_REGISTERED"
    case complete = "COMPLETE"
}
