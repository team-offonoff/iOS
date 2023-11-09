//
//  UseCase.swift
//  Domain
//
//  Created by 박소윤 on 2023/11/03.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Core

public protocol UseCase {
    associatedtype RepositoryInterface
    init(repository: RepositoryInterface)
}
