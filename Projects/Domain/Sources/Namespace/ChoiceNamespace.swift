//
//  ChoiceNamespace.swift
//  Domain
//
//  Created by 박소윤 on 2023/12/12.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

public enum ChoiceTemp {
    
    public static let identifier: String = "Choice."
    
    public enum Option: String {
        
        public static let identifier: String = "Option."
        
        case A
        case B
        
        public var identifier: String {
            ChoiceTemp.identifier + Option.identifier + String(describing: self)
        }
    }
}
