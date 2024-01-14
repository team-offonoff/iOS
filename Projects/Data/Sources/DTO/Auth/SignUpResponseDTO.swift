//
//  SignUpResponseDTO.swift
//  Data
//
//  Created by 박소윤 on 2023/12/23.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Domain

struct SignUpResponseDTO: Decodable {
    let memberId : Int
    let joinStatus : String
    let accessToken: String?
}

extension SignUpResponseDTO: Domainable {
    func toDomain() -> User {
        .init(
            isNewMember: nil,
            memberId: memberId,
            joinStatus: JoinStatus.toDomain(joinStatus),
            accessToken: accessToken
        )
    }
}
