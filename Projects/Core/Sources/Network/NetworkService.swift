//
//  NetworkService.swift
//  Core
//
//  Created by 박소윤 on 2023/10/24.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

public final class NetworkService {
    
    public static let shared = NetworkService()
    
    private init() { }

    private var baseURL: String {
        let url = Bundle.main.infoDictionary?["BASE_URL"] as? String ?? ""
        return "http://" + url
    }

    private var token: String? {
        UserManager.shared.accessToken
    }
    
    private var baseUrlComponents: URLComponents? {
        URLComponents(string: baseURL)
    }

    public func dataTask<DTO: Decodable>(request: URLRequest) async throws -> NetworkResult<DTO> {
        
        var request = request
        if let token = token {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            print("There is no jwt token")
        }

        let (data, response) = try await URLSession.shared.data(for: request)
        print("🌐 " + (request.httpMethod ?? "") + ": " + String(request.url?.absoluteString ?? ""))

        guard let httpResponse = response as? HTTPURLResponse else {
            print("NetworkError.exceptionParseFailed")
            throw NetworkError.exceptionParseFailed
        }

        guard let dto = try? JSONDecoder().decode(NetworkRespone<DTO>.self, from: data) else {
            print("NetworkError.jsonParseFailed")
            throw NetworkError.jsonParseFailed
        }

        guard let serviceCode = NetworkServiceCode(rawValue: dto.code) else {
            print("NetworkError.exceptionParseFailed")
            throw NetworkError.exceptionParseFailed
        }

        print("✅ status: \(httpResponse.statusCode)")
        print("👀 data: \(dto)")
        
        return (code: serviceCode, data: dto.data)
    }
}
