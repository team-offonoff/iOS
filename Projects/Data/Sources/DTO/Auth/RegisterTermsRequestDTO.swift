//
//  RegisterTermsRequestDTO.swift
//  Data
//
//  Created by 박소윤 on 2024/01/14.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation

struct RegisterTermsRequestDTO: Encodable {
    let memberId: Int
    let listenMarketing: Bool
    
    enum CodingKeys: String, CodingKey {
        case memberId
        case listenMarketing = "listen_marketing"
    }
}
