//
//  Paging.swift
//  Domain
//
//  Created by 박소윤 on 2023/12/12.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

public struct Paging{
    
    public init(
        page: Int,
        size: Int = 10,
        last: Bool
    ) {
        self.page = page
        self.size = size
        self.last = last
    }
    
    public var page: Int
    public let size: Int
    public let last: Bool
}
