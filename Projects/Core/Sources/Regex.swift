//
//  Regex.swift
//  Core
//
//  Created by 박소윤 on 2023/11/12.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

public struct Regex {
    
    public enum RegexPattern: String {
        case nickname = "^[0-9a-zA-Z가-힣]{1,12}"
    }
    
    public static func validate(data: String, pattern: RegexPattern) -> Bool {
        data.range(of: pattern.rawValue, options: .regularExpression) != nil
    }
}
