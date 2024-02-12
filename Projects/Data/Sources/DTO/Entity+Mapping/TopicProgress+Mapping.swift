//
//  TopicProgress+Mapping.swift
//  Data
//
//  Created by 박소윤 on 2024/02/10.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import Domain

extension Topic.Progress {
    func toDTO() -> String {
        switch self {
        case .ongoing:          return "VOTING"
        case .termination:      return "CLOSED"
        }
    }
}
