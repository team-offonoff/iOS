//
//  RevoteRequestDTO.swift
//  Data
//
//  Created by 박소윤 on 2024/01/10.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation

struct RevoteRequestDTO: Encodable {
    public let modifiedOption: String
    public let modifiedAt: Int
}
