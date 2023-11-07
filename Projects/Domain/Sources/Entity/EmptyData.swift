//
//  EmptyData.swift
//  Domain
//
//  Created by 박소윤 on 2023/11/06.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

public struct EmptyData: Decodable, Domainable {
    public typealias Output = Any
    public func toDomain() -> Output {
        (Any).self
    }
}
