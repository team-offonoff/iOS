//
//  AuthRepository.swift
//  Domain
//
//  Created by 박소윤 on 2023/12/23.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Core

public protocol AuthRepository: Repository{
    func generateProfile(request: GenerateProfileUseCaseRequestValue) -> NetworkResultPublisher<User?>
    func registerTerms(request: RegisterTersmUseCaseRequestValue) -> NetworkResultPublisher<User?>
}
