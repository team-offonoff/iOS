//
//  DeleteProfileImageUseCase.swift
//  Domain
//
//  Created by 박소윤 on 2024/02/09.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation

public protocol DeleteProfileImageUseCase: UseCase {
    func execute() -> NetworkResultPublisher<Any?>
}

public final class DefaultDeleteProfileImageUseCase: DeleteProfileImageUseCase{
    
    public init(repository: any MemberRepository) {
        self.repository = repository
    }
    
    private let repository: any MemberRepository
    
    public func execute() -> NetworkResultPublisher<Any?> {
        repository.deleteProfileImage()
    }
}
