//
//  NetworkServiceResultPublisher.swift
//  Data
//
//  Created by 박소윤 on 2023/10/24.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Combine

public typealias NetworkServiceResult<DTO> = (isSuccess: Bool, data: DTO, error: NetworkErrorResponeDTO?)
public typealias NetworkServiceResultPublisher<DTO> = AnyPublisher<(isSuccess: Bool, data: DTO, error: NetworkErrorResponeDTO?), Never>
