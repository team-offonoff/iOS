//
//  TopicNamespace.swift
//  Domain
//
//  Created by 박소윤 on 2023/12/12.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

public enum TopicTemp {
    
    private static let identifier = "Topic."
        
    enum Side: String {
        
        public static let identifier = "Side."
        
        case A
        case B
    }
    
    enum ContentType {
        
        public static let identifier = "ContentType."
        
        case text
        case image
    }
    
    enum State {
        
        public static let identifier = "State."
        
        case normal
        case choiced
    }
    
    public enum Action: String {
        
        private static let identifier = "Action."
        public static let forBottomSheet: [Action] = [.hide, .report, .reset]
        
        case choiceA
        case choiceB
        case expandImage
        case reset
        case report
        case hide
        
        public var identifier: String {
            TopicTemp.identifier + Action.identifier + String(describing: self)
        }
    }
}
