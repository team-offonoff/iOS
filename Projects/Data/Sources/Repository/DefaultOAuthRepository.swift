//
//  DefaultOAuthRepository.swift
//  Data
//
//  Created by 박소윤 on 2023/11/11.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Domain
import Core

public final class DefaultOAuthRepository: OAuthRepository {
    
    private let networkService: NetworkService = NetworkService.shared
    
    public init() { }
    
    public func login(request: LoginUseCaseRequestValue) -> NetworkResultPublisher<User?> {
        
        var urlComponents = networkService.baseUrlComponents
        urlComponents?.path = "/oauth/kakao/authorize"
        
        guard let requestBody = try? JSONEncoder().encode(makeDTO()) else {
            fatalError("json parsing error")
        }
        guard let urlRequest = urlComponents?.toURLRequest(method: .post, httpBody: requestBody) else {
            fatalError("url parsing error")
        }
        
        return dataTask(request: urlRequest, responseType: LoginResponseDTO.self)
        
        func makeDTO() -> LoginRequestDTO {
            .init(idToken: request.idToken)
        }
    }
}
