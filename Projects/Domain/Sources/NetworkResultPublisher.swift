//
//  NetworkResultPublisher.swift
//  Domain
//
//  Created by 박소윤 on 2023/12/11.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Combine

public typealias NetworkResultPublisher<DTO> = AnyPublisher<(isSuccess: Bool, data: DTO, error: ErrorContent?), Never>
