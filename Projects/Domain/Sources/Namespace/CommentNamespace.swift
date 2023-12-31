//
//  CommentNamespace.swift
//  Domain
//
//  Created by 박소윤 on 2023/12/13.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

extension Comment {
    
    public static let identifier = "Comment."
    
    public enum State: Identifiable{
        
        public static let identifier = "State."
        
        case like
        case dislike
    }
    
    public enum Action: Identifiable {
        
        public static let identifier = "Action."
        
        case fetch
        case register
        case report
        case modify
        case delete
        case like
        case dislike
        case tapEtc
        case showBottomSheet
    }
}
