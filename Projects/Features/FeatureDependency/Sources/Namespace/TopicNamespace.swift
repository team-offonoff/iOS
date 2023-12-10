//
//  TopicNamespace.swift
//  FeatureDependency
//
//  Created by 박소윤 on 2023/12/10.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Domain

public extension Topic {
        
    enum Side: String {
        case A
        case B
    }
    
    enum ContentType {
        case text
        case image
    }
    
    enum State {
        case normal
        case choiced
    }
    
    enum Action: String {
        case choiceA
        case choiceB
        case expandImage
        case reset
        case report
        case hide
    }
}

public protocol EnumerationIdentifiable {
    var identifier: String { get }
}

extension Topic.Action: EnumerationIdentifiable {
    public var identifier: String {
        "Action." + String(describing: self)
    }
}
