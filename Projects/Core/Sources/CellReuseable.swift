//
//  CellReuseable.swift
//  Core
//
//  Created by 박소윤 on 2023/10/03.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

public protocol CellReuseable{
    static var cellIdentifier: String { get }
}

public extension CellReuseable{
    static var cellIdentifier: String {
        String(describing: self)
    }
}
