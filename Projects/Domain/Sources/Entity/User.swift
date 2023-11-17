//
//  User.swift
//  Domain
//
//  Created by 박소윤 on 2023/11/16.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

public struct User {
    
    public init (
        newMember: Bool,
        accessToken: String)
    {
        self.newMember = newMember
        self.accessToken = accessToken
    }
    
    public let newMember: Bool?
    public let accessToken: String?
}
