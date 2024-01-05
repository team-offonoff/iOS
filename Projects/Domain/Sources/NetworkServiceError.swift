//
//  NetworkSerivceError.swift
//  Domain
//
//  Created by 박소윤 on 2023/12/11.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

public enum NetworkServiceError: String, Error {
    
    case emptyAuthorization = "EMPTY_AUTHORIZATION"
    case invalidField = "INVALID_FIELD"
    
    //MARK: Topic
    case TOPIC_NOT_FOUND
    case DUPLICATE_TOPIC_REPORT
    case ILLEGAL_TOPIC_STATUS_CHANGE
    case VOTED_BY_AUTHOR
    case FUTURE_TIME_REQUEST
    case MEMBER_NOT_VOTE
    case DUPLICATE_VOTE
    
    //MARK: Auth
    case ILLEGAL_JOIN_STATUS
    
    //MARK: Comment
    case INVALID_LENGTH_OF_FIELD
    case UNABLE_TO_VIEW_COMMENTS
    case ILLEGAL_COMMENT_STATUS_CHANGE
    
    //MARK: Image Presigned
    case ILLEGAL_FILE_EXTENSION
    
    //MARK: Custom
    case IMAGE_UPLOAD_FAIL
}
