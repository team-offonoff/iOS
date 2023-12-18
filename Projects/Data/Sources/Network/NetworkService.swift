//
//  NetworkService.swift
//  Core
//
//  Created by 박소윤 on 2023/10/24.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Combine
import Core

public final class NetworkService {
    
    public static let shared = NetworkService()
    
    private init() { }

    private var baseURL: String {
        let url = Bundle.main.infoDictionary?["BASE_URL"] as? String ?? ""
        return "http://" + url
    }

    private var token: String? {
        if let devToken = Bundle.main.infoDictionary?["DEV_TOKEN"] as? String {
            return devToken
        }
        return UserManager.shared.accessToken
    }
    
    public var baseUrlComponents: URLComponents? {
        URLComponents(string: baseURL)
    }
    
    public func dataTask<DTO: Decodable>(request: URLRequest, type: DTO.Type) -> NetworkServiceResultPublisher<DTO?> {
        
        print("🌐 " + (request.httpMethod ?? "") + ": " + String(request.url?.absoluteString ?? ""))
        
        return URLSession.shared.dataTaskPublisher(for: requestWithToken())
            .tryMap{ data, response in
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("NetworkError.exceptionParseFailed")
                    throw NetworkError.exceptionParseFailed
                }
                print("✅ status: \(httpResponse.statusCode)")
                
                if httpResponse.statusCode == 200 {
                    if data.isEmpty {
                        return (true, nil, nil)
                    }
                    return (true, try decode(data, DTO.self), nil)
                }
                else {
                    let error = try decode(data, NetworkErrorResponeDTO.self)
                    return (false, nil, error)
                }
            }
            .replaceError(with: (false, nil, nil))
            .eraseToAnyPublisher()
        
        func requestWithToken() -> URLRequest{
            var request = request
            if let token = token{
                request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            return request
        }
        
        func decode<T: Decodable>(_ data: Data, _ type: T.Type) throws -> T{
            guard let dto = try? JSONDecoder().decode(type.self, from: data) else {
                print("NetworkError.jsonParseFailed")
                throw NetworkError.jsonParseFailed
            }
            print("👀 data: \(dto)")
            return dto
        }
    }
}

