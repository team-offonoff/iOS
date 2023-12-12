//
//  PagingContentResponseDTO.swift
//  Data
//
//  Created by 박소윤 on 2023/12/12.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Domain

struct PagingContentResponseDTO<DTO: Decodable & Domainable>: Decodable {
    
    struct PageInformationResponseDTO: Decodable {
        let page: Int
        let size: Int
        let empty: Bool
        let last: Bool
    }
    
    let pageInfo: PageInformationResponseDTO
    let data: [DTO]
}

extension PagingContentResponseDTO: Domainable {
    
    func toDomain() -> (page: PageEntity, data: [DTO.Output]) {
        (pageInfo.toDomain(), data.map{ $0.toDomain() })
    }
    
}

extension PagingContentResponseDTO.PageInformationResponseDTO: Domainable {
    
    func toDomain() -> PageEntity {
        .init(page: page, size: size, isEmpty: empty, last: last)
    }
}
