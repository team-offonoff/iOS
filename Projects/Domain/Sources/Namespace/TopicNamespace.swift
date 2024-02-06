//
//  TopicNamespace.swift
//  Domain
//
//  Created by 박소윤 on 2023/12/12.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

extension Topic {
    
    private static let identifier = "Topic."
        
    public enum Side: String, CaseIterable {
        
        public static let identifier = "Side."
        
        case A
        case B
    }
    
    public enum ContentType {
        
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
        
        case choiceA
        case choiceB
        case expandImage
        case revote
        case report
        case hide
        case showBottomSheet
        case showImagePicker
        
        public var identifier: String {
            Topic.identifier + Action.identifier + String(describing: self)
        }
    }
    
    public enum Tag {
        case competition
    }
    
    public enum Progress: CaseIterable {
        case ongoing
        case termination
    }
}
