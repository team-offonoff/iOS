//
//  LoginResponseDTO.swift
//  Data
//
//  Created by 박소윤 on 2023/11/16.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Domain

struct LoginResponseDTO: Decodable, Domainable {
    
    let newMember: Bool
    let accessToken: String
    
    func toDomain() -> User {
        .init(
            newMember: newMember,
            accessToken: accessToken
        )
    }
}
