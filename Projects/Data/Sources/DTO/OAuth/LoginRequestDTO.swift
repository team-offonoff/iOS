//
//  LoginRequestDTO.swift
//  Data
//
//  Created by 박소윤 on 2023/11/16.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

struct LoginRequestDTO: Encodable {
    
    enum CodingKeys: String, CodingKey {
        case type, provider, code
        case redirectUri = "redirect_uri"
        case idToken = "id_token"
    }
    
    let type : String = "BY_IDTOKEN"
    let provider: String? = nil
    let code: String? = nil
    let redirectUri: String? = nil
    let idToken: String
}
