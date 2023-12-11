//
//  DefaultCategoryRepository.swift
//  Data
//
//  Created by 박소윤 on 2023/11/21.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Domain
import Core

public final class DefaultCategoryRepository: CategoryRepository {

    private let networkService: NetworkService = NetworkService.shared
    
    public init() { }
    
    public func generateCategory(request: GenerateCategoryUseCaseRequestValue) -> NetworkResultPublisher<Any?> {
        
        var urlComponents = networkService.baseUrlComponents
        urlComponents?.path = "/categories"
        
        guard let requestBody = try? JSONEncoder().encode(makeDTO()),
              let urlRequest = urlComponents?.toURLRequest(method: .post, httpBody: requestBody) else {
            fatalError("json encoding or url parsing error")
        }
        
        return dataTask(request: urlRequest)
        
        func makeDTO() -> GenerateCategoryRequestDTO {
            .init(name: request.name, topicSide: request.topicSide.rawValue)
        }
    }
}
