//
//  SignUpUseCase.swift
//  Domain
//
//  Created by 박소윤 on 2023/12/23.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

public protocol SignUpUseCase: UseCase {
    func execute(request: SignUpUseCaseRequestValue) -> NetworkResultPublisher<User?>
}

public final class DefaultSignUpUseCase: SignUpUseCase {
    
    private let repository: AuthRepository
    
    public init(repository: AuthRepository) {
        self.repository = repository
    }
    
    public func execute(request: SignUpUseCaseRequestValue) -> NetworkResultPublisher<User?> {
        return repository.signUp(request: request)
    }
}

public struct SignUpUseCaseRequestValue {
    
    public let memberId: Int
    public let nickname: String
    public let birth: String
    public let gender: Gender
    public let job: String
    
    public init(
        memberId: Int,
        nickname: String,
        birth: String,
        gender: Gender,
        job: String
    ) {
        self.memberId = memberId
        self.nickname = nickname
        self.birth = birth
        self.gender = gender
        self.job = job
    }
}
