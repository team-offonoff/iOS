//
//  NetworkResult.swift
//  Core
//
//  Created by 박소윤 on 2023/10/24.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Combine

public typealias NetworkResultPublisher<DTO: Decodable>
    = AnyPublisher<(code: NetworkServiceCode, data: DTO, error: NetworkErrorRespone.ErrorContent?), Never>
