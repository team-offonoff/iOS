//
//  OnboardingUseCaseInterface.swift
//  Domain
//
//  Created by 박소윤 on 2023/10/14.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

public protocol LoginUseCase {
    func execute(email: String) -> String
}
