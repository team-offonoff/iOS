//
//  URLComponents++.swift
//  Core
//
//  Created by 박소윤 on 2023/10/24.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

extension URLComponents {
    
    func toURLRequest(method: HTTPMethod, httpBody: Data? = nil, contentType: String = "application/json") -> URLRequest? {
        
        guard let url = url else { return nil }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        if let httpBody = httpBody {
            urlRequest.httpBody = httpBody
            urlRequest.addValue(contentType, forHTTPHeaderField: "Content-Type")
        }
        
        return urlRequest
    }
}
