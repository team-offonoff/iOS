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

extension ImageBucket {
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

public final class DefaultPresignedImageRepository: PresignedImageRepository {

    private let networkService: NetworkService = NetworkService.shared
    
    public init() { }
    
    public func upload(bucket: ImageBucket, request image: UIImage) async throws -> String {

        let response = await requestPresignedUrl()
        
        guard let url = response.data?.presignedUrl else {
            throw NetworkServiceError.IMAGE_UPLOAD_FAIL
        }
        
        let urlComponents = URLComponents(string: url)
        
        guard let urlRequest = urlComponents?.toURLRequest(method: .put, httpBody: image.jpegData(compressionQuality: 1), contentType: "image/jpeg") else {
            fatalError("url parsing error")
        }
        
        if await networkService.dataTask(request: urlRequest, type: EmptyData.self, requireToken: false).isSuccess {
            //쿼리스트링을 제외한 URL을 반환한다
            return String(url.split(separator: "?").first!)
        } else {
            throw NetworkServiceError.IMAGE_UPLOAD_FAIL
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
