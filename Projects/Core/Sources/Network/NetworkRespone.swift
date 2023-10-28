//
//  NetworkRespone.swift
//  Core
//
//  Created by 박소윤 on 2023/10/24.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

struct NetworkRespone<DTO: Decodable>: Decodable {
    let code: String
    let message: String
    let data: DTO
}
