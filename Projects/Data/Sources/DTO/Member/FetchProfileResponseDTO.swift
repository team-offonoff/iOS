//
//  FetchProfileResponseDTO.swift
//  Data
//
//  Created by 박소윤 on 2024/02/19.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import Domain

struct FetchProfileResponseDTO: Decodable {
    let profileImageUrl: String?
    let nickname: String
    let birth: String
    let gender: String
    let job: String
}

extension FetchProfileResponseDTO: Domainable {
    func toDomain() -> Profile {
        .init(
            profileImageUrl: URL(string: profileImageUrl ?? ""),
            nickname: nickname,
            birth: birth,
            gender: Gender.toDomain(gender),
            job: job
        )
    }
}
