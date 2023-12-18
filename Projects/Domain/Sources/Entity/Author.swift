//
//  Author.swift
//  Domain
//
//  Created by 박소윤 on 2023/12/18.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

public struct Author {
    public let id: Int
    public let nickname: String
    public let profileImageUrl: URL?
    
    public init(
        id: Int,
        nickname: String,
        profileImageUrl: URL?
    ) {
        self.id = id
        self.nickname = nickname
        self.profileImageUrl = profileImageUrl
    }
    
}
