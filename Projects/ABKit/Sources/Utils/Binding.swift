//
//  Binding.swift
//  ABKit
//
//  Created by 박소윤 on 2023/10/12.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

public protocol Binding{
    associatedtype DataType
    func binding(data: DataType)
}
