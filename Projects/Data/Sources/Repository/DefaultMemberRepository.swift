//
//  DefaultMemberRepository.swift
//  Data
//
//  Created by 박소윤 on 2024/02/07.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import Domain

public final class DefaultMemberRepository: MemberRepository {
    
    public init() { }
    
    private let networkService: NetworkService = NetworkService.shared
    
    private let basePath = "members"
    
    public func modifyInformation(request: ModifyMemberInformationUseCaseRequestValue) -> NetworkResultPublisher<Any?> {
        
        var urlComponents = networkService.baseUrlComponents
        urlComponents?.path = path(basePath) + path("profile") + path("information")
        
        guard let requestBody = try? JSONEncoder().encode(makeDTO()) else {
            fatalError("json parsing error")
        }
        guard let urlRequest = urlComponents?.toURLRequest(method: .put, httpBody: requestBody) else {
            fatalError("url parsing error")
        }
        
        return dataTask(request: urlRequest)
        
        func makeDTO() -> ModifyMemberInformationRequestDTO {
            return .init(nickname: request.nickname, job: request.job.rawValue)
        }
    }
    
//    public func modifyProfileImage() -> NetworkResultPublisher<Any?> {
//
//    }
//
//    public func deleteProfileImage() -> NetworkResultPublisher<Any?> {
//
//    }
}
