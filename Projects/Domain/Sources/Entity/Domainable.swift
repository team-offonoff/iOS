//
//  Convertable.swift
//  Domain
//
//  Created by 박소윤 on 2023/11/03.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

public protocol Domainable where Self: Decodable{
    associatedtype Output
    func toDomain() -> Output
}
