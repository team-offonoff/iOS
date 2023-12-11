//
//  ServiceError.swift
//  Domain
//
//  Created by 박소윤 on 2023/12/11.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

public enum SerivceError: String {
    case invalidField = "INVALID_FIELD"
    case topicNotFound = "TOPIC_NOT_FOUND"
    case duplicateTopicReport = "DUPLICATE_TOPIC_REPORT"
}
