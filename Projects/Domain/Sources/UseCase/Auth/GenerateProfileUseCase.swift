//
//  GenerateProfileUseCase.swift
//  Domain
//
//  Created by 박소윤 on 2023/12/23.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

public protocol GenerateProfileUseCase: UseCase {
    func execute(request: GenerateProfileUseCaseRequestValue) -> NetworkResultPublisher<User?>
}

public final class DefaultGenerateProfileUseCase: GenerateProfileUseCase {
    
    private let repository: AuthRepository
    
    public init(repository: AuthRepository) {
        self.repository = repository
    }
    
    public func execute(request: GenerateProfileUseCaseRequestValue) -> NetworkResultPublisher<User?> {
        return repository.generateProfile(request: request)
    }
}

public struct GenerateProfileUseCaseRequestValue {
    
    public let memberId: Int
    public let nickname: String
    public let birth: String
    public let gender: Gender
    public let job: Job
    
    public init(
        memberId: Int,
        nickname: String,
        birth: String,
        gender: Gender,
        job: Job
    ) {
        self.memberId = memberId
        self.nickname = nickname
        self.birth = birth
        self.gender = gender
        self.job = job
    }
}
