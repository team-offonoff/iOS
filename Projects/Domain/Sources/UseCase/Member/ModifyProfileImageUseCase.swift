//
//  ModifyProfileImageUseCase.swift
//  Domain
//
//  Created by 박소윤 on 2024/01/16.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit
import Combine

public protocol ModifyProfileImageUseCase: UseCase {
    func execute(request image: UIImage) async -> NetworkResultPublisher<Any?>
}

public final class DefaultModifyProfileImageUseCase: ModifyProfileImageUseCase {
    
    private let repository: MemberRepository
    
    public init(repository: MemberRepository) {
        self.repository = repository
    }
    
    public func execute(request image: UIImage) async -> NetworkResultPublisher<Any?> {
        await repository.modifyProfile(image: image)
    }
}
