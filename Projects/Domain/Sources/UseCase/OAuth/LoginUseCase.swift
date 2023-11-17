//
//  LoginUseCase.swift
//  Domain
//
//  Created by 박소윤 on 2023/11/15.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Core

public protocol LoginUseCase: UseCase {
    func execute(request: LoginUseCaseRequestValue) -> NetworkResultPublisher<User?>
}

public final class DefaultLoginUseCase: LoginUseCase {
    
    private let repository: OAuthRepository
    
    public init(repository: OAuthRepository) {
        self.repository = repository
    }
    
    public func execute(request: LoginUseCaseRequestValue) -> NetworkResultPublisher<User?> {
        repository.login(request: request)
    }
}

public struct LoginUseCaseRequestValue {
    public let idToken: String
}
