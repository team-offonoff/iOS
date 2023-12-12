//
//  PageResponseDTO.swift
//  Data
//
//  Created by 박소윤 on 2023/12/12.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

struct PageResponseDTO<DTO: Decodable>: Decodable {
    
    struct PageInformationResponseDTO: Decodable {
        let page: Int
        let size: Int
        let empty: Bool
        let last: Bool
    }
    
    let pageInfo: PageInformationResponseDTO
    let data: [DTO]
}
