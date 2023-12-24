//
//  LoginResponseDTO.swift
//  Data
//
//  Created by 박소윤 on 2023/11/16.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Domain
import Core

struct LoginResponseDTO: Decodable, Domainable {
    
    let newMember: Bool
    let memberId: Int
    let joinStatus: String
    let accessToken: String?
    
    func toDomain() -> User {
        .init(
            isNewMember: newMember,
            memberId: memberId,
            joinStatus: JoinStatus.toDomain(joinStatus),
            accessToken: accessToken
        )
    }
}
