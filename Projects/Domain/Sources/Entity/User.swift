//
//  User.swift
//  Domain
//
//  Created by 박소윤 on 2023/11/16.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Core

public struct User {
    
    //for login response initializer
    public init(
        isNewMember: Bool?,
        memberId: Int?,
        joinStatus: JoinStatus?,
        accessToken: String?
    ) {
        self.isNewMember = isNewMember
        self.memberId = memberId
        self.joinStatus = joinStatus
        self.accessToken = accessToken
    }
    
    public let isNewMember: Bool?
    public let memberId: Int?
    public let joinStatus: JoinStatus?
    public let accessToken: String?
}
