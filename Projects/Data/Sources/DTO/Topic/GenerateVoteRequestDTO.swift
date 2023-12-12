//
//  GenerateVoteRequestDTO.swift
//  Data
//
//  Created by 박소윤 on 2023/12/11.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

struct GenerateVoteRequestDTO: Encodable {
    let choiceOption: String
    let votedAt: Int
}
