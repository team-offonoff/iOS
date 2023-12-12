//
//  TopicNamespace.swift
//  Core
//
//  Created by 박소윤 on 2023/12/11.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

public enum TopicTemp {
        
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
    
    public enum Action: String {
        case choiceA
        case choiceB
        case expandImage
        case reset
        case report
        case hide
    }
    
    public static let bottomSheetActions: [Action] = [.hide, .report, .reset]
}

public protocol EnumerationIdentifiable {
    var identifier: String { get }
}

extension TopicTemp.Action: EnumerationIdentifiable {
    public var identifier: String {
        "Action." + String(describing: self)
    }
}
