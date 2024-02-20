//
//  ModifyProfileImageDTO.swift
//  Data
//
//  Created by 박소윤 on 2024/02/09.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import Domain

struct ModifyProfileImageDTO: Encodable {
    let imageUrl: String
}

extension ModifyProfileImageDTO: Domainable {
    func toDomain() -> String {
        imageUrl
    }
}
