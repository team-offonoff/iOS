//
//  Profile.swift
//  Domain
//
//  Created by 박소윤 on 2024/02/19.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation

public struct Profile {
    
    public init(
        profileImageUrl: URL?,
        nickname: String,
        birth: String,
        gender: Gender?,
        job: String
    ) {
        self.profileImageUrl = profileImageUrl
        self.nickname = nickname
        self.birth = birth
        self.gender = gender
        self.job = job
    }
    
    public let profileImageUrl: URL?
    public let nickname: String
    public let birth: String
    public let gender: Gender?
    public let job: String
}
