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
}
