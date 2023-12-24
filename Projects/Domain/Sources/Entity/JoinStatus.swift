//
//  JoinStatus.swift
//  Domain
//
//  Created by 박소윤 on 2023/12/24.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

public enum JoinStatus: CaseIterable {
    case empty
    case authRegistered
    case personalRegistered
    case complete
}
