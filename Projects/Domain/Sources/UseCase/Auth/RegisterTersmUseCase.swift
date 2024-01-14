//
//  RegisterTersmUseCase.swift
//  Domain
//
//  Created by 박소윤 on 2024/01/14.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation

public protocol RegisterTersmUseCase: UseCase {
    func execute(request: RegisterTersmUseCaseRequestValue) -> NetworkResultPublisher<User?>
}

public final class DefaultRegisterTersmUseCase: RegisterTersmUseCase {
    
    private let repository: AuthRepository
    
    public init(repository: AuthRepository) {
        self.repository = repository
    }
    
    public func execute(request: RegisterTersmUseCaseRequestValue) -> NetworkResultPublisher<User?> {
        repository.registerTerms(request: request)
    }
}

public struct RegisterTersmUseCaseRequestValue {
    
    public init(memberId: Int, listenMarketing: Bool) {
        self.memberId = memberId
        self.listenMarketing = listenMarketing
    }
    
    public let memberId: Int
    public let listenMarketing: Bool
}
