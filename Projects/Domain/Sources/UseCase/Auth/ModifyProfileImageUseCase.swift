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
    func execute(request image: UIImage) async throws -> String?
}

public final class DefaultModifyProfileImageUseCase: ModifyProfileImageUseCase {
    
    private let repository: PresignedImageRepository
    
    public init(repository: PresignedImageRepository) {
        self.repository = repository
    }
    
    public func execute(request image: UIImage) async throws -> String? {
        try await repository.upload(bucket: .profile, request: image)
    }
}
