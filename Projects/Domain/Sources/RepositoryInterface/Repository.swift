//
//  Repository.swift
//  Domain
//
//  Created by 박소윤 on 2023/11/03.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Core

public protocol Repository { }

public extension Repository {
    
    func dataTask<DTO: Domainable>(request: URLRequest, responseType: DTO.Type = EmptyData.self) -> NetworkResultPublisher<DTO.Output?> {
        return NetworkService.shared.dataTask(request: request, type: DTO.self)
            .map{ (code, dto, error) in
                return (code, dto?.toDomain(), error)
            }
            .eraseToAnyPublisher()
    }
    
    func arrayDataTask<DTO: Domainable>(request: URLRequest, elementType: DTO.Type) -> NetworkResultPublisher<[DTO.Output]> {
        return NetworkService.shared.dataTask(request: request, type: [DTO].self)
            .map{ (code, dto, error) in
                return (code, dto?.map{ $0.toDomain() } ?? [], error)
            }
            .eraseToAnyPublisher()
    }
}
