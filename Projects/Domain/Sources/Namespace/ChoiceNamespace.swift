//
//  ChoiceNamespace.swift
//  Domain
//
//  Created by 박소윤 on 2023/12/12.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

extension Choice {
    
    public static let identifier: String = "Choice."
    
    public enum Option: String, CaseIterable {
        
        public static let identifier: String = "Option."
        
        case A
        case B
        
        public var identifier: String {
            Choice.identifier + Option.identifier + String(describing: self)
        }
    }
    
    public enum State {
        ///아직 투표하지 않은 경우
        case none
        ///해당 옵션으로 투표한 경우
        case select
        ///다른 옵션으로 투표한 경우
        case unselect
    }

}
