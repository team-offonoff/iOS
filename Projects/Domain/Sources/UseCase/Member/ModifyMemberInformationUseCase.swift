//
//  ModifyMemberInformationUseCase.swift
//  Domain
//
//  Created by 박소윤 on 2024/02/07.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation

public protocol ModifyMemberInformationUseCase: UseCase {
    func execute(request: ModifyMemberInformationUseCaseRequestValue) -> NetworkResultPublisher<Any?>
}

public final class DefaultModifyMemberInformationUseCase: ModifyMemberInformationUseCase{
    
    public init(repository: any MemberRepository) {
        self.repository = repository
    }
    
    private let repository: any MemberRepository
    
    public func execute(request: ModifyMemberInformationUseCaseRequestValue) -> NetworkResultPublisher<Any?> {
        repository.modifyInformation(request: request)
    }
}

public struct ModifyMemberInformationUseCaseRequestValue {
    
    public init(nickname: String, job: Job) {
        self.nickname = nickname
        self.job = job
    }
    
    public let nickname: String
    public let job: Job
}
