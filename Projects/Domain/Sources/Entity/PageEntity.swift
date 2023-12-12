//
//  PageEntity.swift
//  Domain
//
//  Created by 박소윤 on 2023/12/12.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

public struct PageEntity{
    
    public init(
        page: Int,
        size: Int,
        isEmpty: Bool,
        last: Bool
    ) {
        self.page = page
        self.size = size
        self.isEmpty = isEmpty
        self.last = last
    }
    
    public let page: Int
    public let size: Int
    public let isEmpty: Bool
    public let last: Bool
}
