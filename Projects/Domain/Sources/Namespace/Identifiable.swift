//
//  Identifiable.swift
//  Domain
//
//  Created by 박소윤 on 2023/12/16.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

public protocol Identifiable {
    var identifier: String { get }
}

extension Identifiable {
    public var identifier: String {
        String(describing: self)
    }
}
