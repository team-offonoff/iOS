//
//  DefaultAccountRepository.swift
//  Data
//
//  Created by 박소윤 on 2023/12/23.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Domain

public final class DefaultAuthRepository: AuthRepository {
    
    private let networkService: NetworkService = NetworkService.shared
    
    public init() { }
    
    public func generateProfile(request: GenerateProfileUseCaseRequestValue) -> NetworkResultPublisher<User?> {
        
        var urlComponents = networkService.baseUrlComponents
        urlComponents?.path = path("auth") + path("signup") + path("profile")
        
        guard let requestBody = try? JSONEncoder().encode(makeDTO()) else {
            fatalError("json parsing error")
        }
        guard let urlRequest = urlComponents?.toURLRequest(method: .post, httpBody: requestBody) else {
            fatalError("url parsing error")
        }
        
        return dataTask(request: urlRequest, responseType: SignUpResponseDTO.self)
        
        func makeDTO() -> SignUpRequestDTO {
            .init(
                memberId: request.memberId,
                nickname: request.nickname,
                birth: request.birth,
                gender: request.gender.toDTO(),
                job: request.job
            )
        }
    }
    
    public func registerTerms(request: RegisterTersmUseCaseRequestValue) -> NetworkResultPublisher<User?> {
        
        var urlComponents = networkService.baseUrlComponents
        urlComponents?.path = path("auth") + path("signup") + path("terms")
        
        guard let requestBody = try? JSONEncoder().encode(makeDTO()) else {
            fatalError("json parsing error")
        }
        guard let urlRequest = urlComponents?.toURLRequest(method: .post, httpBody: requestBody) else {
            fatalError("url parsing error")
        }
        
        return dataTask(request: urlRequest, responseType: SignUpResponseDTO.self)
        
        func makeDTO() -> RegisterTermsRequestDTO {
            .init(
                memberId: request.memberId,
                listenMarketing: request.listenMarketing
            )
        }
    }
}
