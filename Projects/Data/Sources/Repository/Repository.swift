//
//  Repository.swift
//  Data
//
//  Created by 박소윤 on 2023/10/14.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Domain

public extension Repository {
    
    func path(_ path: Any) -> String {
        "/\(path)"
    }
    
    func dataTask<DTO: Domainable>(request: URLRequest, responseType: DTO.Type = EmptyData.self) -> NetworkResultPublisher<DTO.Output?> {
        return NetworkService.shared.dataTask(request: request, type: DTO.self)
            .map{ (isSuccess, dto, error) in
                return (isSuccess, dto?.toDomain(), error?.toDomain())
            }
            .eraseToAnyPublisher()
    }
    
    func arrayDataTask<DTO: Domainable>(request: URLRequest, elementType: DTO.Type) -> NetworkResultPublisher<[DTO.Output]> {
        return NetworkService.shared.dataTask(request: request, type: [DTO].self)
            .map{ (isSuccess, dto, error) in
                return (isSuccess, dto?.map{ $0.toDomain() } ?? [], error?.toDomain())
            }
            .eraseToAnyPublisher()
    }
}
