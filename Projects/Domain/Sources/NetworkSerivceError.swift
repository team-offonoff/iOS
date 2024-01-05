//
//  NetworkSerivceError.swift
//  Domain
//
//  Created by 박소윤 on 2023/12/11.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

public enum NetworkSerivceError: String {
    case emptyAuthorization = "EMPTY_AUTHORIZATION"
    case votedByAuthor = "VOTED_BY_AUTHOR"
    case futureTimeRequest = "FUTURE_TIME_REQUEST"
    case memberNotVote = "MEMBER_NOT_VOTE"
    case invalidField = "INVALID_FIELD"
    case topicNotFound = "TOPIC_NOT_FOUND"
    case duplicateTopicReport = "DUPLICATE_TOPIC_REPORT"
}
