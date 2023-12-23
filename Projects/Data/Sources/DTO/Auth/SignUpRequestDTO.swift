//
//  SignUpRequestDTO.swift
//  Data
//
//  Created by 박소윤 on 2023/12/23.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

struct SignUpRequestDTO: Encodable {
    let memberId: Int
    let nickname: String
    let birth: String
    let gender: String
    let job: String
}
