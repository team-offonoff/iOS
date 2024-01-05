//
//  DefaultPresignedImageRepository.swift
//  Data
//
//  Created by 박소윤 on 2024/01/04.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit
import Domain

protocol PresignedImageRepository: Repository {
    func upload(bucket: ImageBucket, request: UIImage) async throws -> String?
}

enum ImageBucket {
    
    case profile
    case topic
    
    var method: HTTPMethod {
        switch self {
        case .profile, .topic:      return .post
        }
    }
    
    var path: String {
        switch self {
        case .profile:      return "profile"
        case .topic:        return "topic"
        }
    }
}

final class DefaultPresignedImageRepository: PresignedImageRepository {

    private let networkService: NetworkService = NetworkService.shared
    
    public init() { }
    
    func upload(bucket: ImageBucket, request image: UIImage) async throws -> String? {

        let response = await requestPresignedUrl()
        
        guard let url = response.data?.presignedUrl else {
            return nil
        }
        
        let urlComponents = URLComponents(string: String(url.split(separator: "?").first!))
        
        guard let urlRequest = urlComponents?.toURLRequest(method: .put, httpBody: image.jpegData(compressionQuality: 1), contentType: "image/jpeg") else {
            fatalError("url parsing error")
        }
        
        if await networkService.dataTask(request: urlRequest, type: EmptyData.self).isSuccess {
            return url
        } else {
            throw ABError.imageUpload
        }
        
        func requestPresignedUrl() async -> NetworkServiceResult<PresignedImageResponseDTO?> {

            var urlComponents = networkService.baseUrlComponents
            urlComponents?.path = path("images") + path(bucket.path)

            guard let requestBody = try? JSONEncoder().encode(makeDTO()) else {
                fatalError("json parsing error")
            }
            guard let urlRequest = urlComponents?.toURLRequest(method: .post, httpBody: requestBody) else {
                fatalError("url parsing error")
            }

            return await networkService.dataTask(request: urlRequest, type: PresignedImageResponseDTO.self)

            func makeDTO() -> PresignedImageRequestDTO {
                let id = UUID().uuidString
                let fileKey = "\(bucket.path)/\(id).jpeg"
                return .init(fileName: fileKey)
            }
        }
    }
    
}
