//
//  FetchProfileUseCase.swift
//  Domain
//
//  Created by 박소윤 on 2024/02/19.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import Combine

public protocol FetchProfileUseCase: UseCase {
    func execute() -> NetworkResultPublisher<Profile?>
}

public final class DefaultFetchProfileUseCase: FetchProfileUseCase {
    
    private let repository: MemberRepository
    
    public init(repository: MemberRepository) {
        self.repository = repository
    }
    
    public func execute() -> NetworkResultPublisher<Profile?> {
        repository.fetchProfile()
    }
}
