//
//  GenerateCategoryRequestDTO.swift
//  Data
//
//  Created by 박소윤 on 2023/11/21.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

struct GenerateCategoryRequestDTO: Encodable {
    let name: String
    let topicSide: String
}
