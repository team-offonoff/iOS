//
//  Alarm+Namespace.swift
//  Domain
//
//  Created by 박소윤 on 2024/01/17.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation

extension Alarm {
    
    public enum Subject: CaseIterable {
        case topicVote
        case topicWrite
    }
    
    public enum Case{
        case comment
        case like
        case topicEnd
        case breakThrough
    }
}
