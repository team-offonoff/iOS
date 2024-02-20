//
//  DefaultMemberRepository.swift
//  Data
//
//  Created by 박소윤 on 2024/02/07.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit
import Domain
import Combine

public final class DefaultMemberRepository: MemberRepository {
    
    public init() { }
    
    private let networkService: NetworkService = NetworkService.shared
    private let presignedImageRepository: PresignedImageRepository = DefaultPresignedImageRepository()
    
    private let basePath = "members"
    
    public func fetchProfile() -> NetworkResultPublisher<Profile?> {
        
        var urlComponents = networkService.baseUrlComponents
        urlComponents?.path = path(basePath) + path("profile")
        
        guard let urlRequest = urlComponents?.toURLRequest(method: .get) else {
            fatalError("url parsing error")
        }
        
        return dataTask(request: urlRequest, responseType: FetchProfileResponseDTO.self)
        
    }
    
    public func modifyProfile(request: ModifyMemberInformationUseCaseRequestValue) -> NetworkResultPublisher<Any?> {
        
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
    
    public func modifyProfile(image: UIImage) async -> NetworkResultPublisher<String?> {
        
        var urlComponents = networkService.baseUrlComponents
        urlComponents?.path = path(basePath) + path("profile") + path("image")
        
        do {
            let dto = try await makeDTO()
            print(dto)
            guard let requestBody = try? JSONEncoder().encode(dto) else {
                fatalError("json parsing error")
            }
            guard let urlRequest = urlComponents?.toURLRequest(method: .put, httpBody: requestBody) else {
                fatalError("url parsing error")
            }
            return dataTask(request: urlRequest, responseType: ModifyProfileImageDTO.self)
        }
        catch NetworkServiceError.IMAGE_UPLOAD_FAIL {
            print("image upload 실패")
            return Just((false, nil, nil)).eraseToAnyPublisher()
        }
        catch {
            fatalError()
        }
        
        func makeDTO() async throws -> ModifyProfileImageDTO {
            .init(imageUrl: try await presignedImageRepository.upload(bucket: .profile, request: image))
        }
    }

    public func deleteProfileImage() -> NetworkResultPublisher<Any?> {
        
        var urlComponents = networkService.baseUrlComponents
        urlComponents?.path = path(basePath) + path("profile") + path("image")
        
        guard let urlRequest = urlComponents?.toURLRequest(method: .delete) else {
            fatalError("url parsing error")
        }
        
        return dataTask(request: urlRequest)
    }
}
