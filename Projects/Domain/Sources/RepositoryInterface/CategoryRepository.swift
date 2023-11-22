//
//  CategoryRepository.swift
//  Domain
//
//  Created by 박소윤 on 2023/11/21.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Core

public protocol CategoryRepository: Repository {
    func generateCategory(request: GenerateCategoryUseCaseRequestValue) -> NetworkResultPublisher<Any?>
}
