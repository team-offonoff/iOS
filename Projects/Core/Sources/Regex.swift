//
//  Regex.swift
//  Core
//
//  Created by 박소윤 on 2023/11/12.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

public enum Regex {
    
    case nickname
    case topicTitle //한글, 영문, 숫자, 특수문자 최대 20자 
    case topicKeyword //한글, 영문, 숫자 최대 6자
    case choiceContent //한글, 영문, 숫자, 특수문자 최대 25자 
    
    public static func validate(data: String, pattern: Regex) -> Bool {
        data.range(of: pattern.configuration.expression, options: .regularExpression) != nil
    }
}

extension Regex {
    
    public var limitCount: Int {
        configuration.limitCount
    }
    
    fileprivate struct RegexConfiguration {
        fileprivate let expression: String
        fileprivate let limitCount: Int
    }
    
    fileprivate var configuration: RegexConfiguration {
        switch self {
        case .nickname:
            return .init(expression: "^[0-9a-zA-Zㄱ-ㅎ가-힣]{1,8}$", limitCount: 8)
        case .topicTitle:
            return .init(expression: "^[0-9a-zA-Zㄱ-ㅎ가-힣!@#$%^()]{1,20}$", limitCount: 20)
        case .topicKeyword:
            return .init(expression: "^[0-9a-zA-Zㄱ-ㅎ가-힣]{1,6}$", limitCount: 6)
        case .choiceContent:
            return .init(expression: "^[0-9a-zA-Zㄱ-ㅎ가-힣!@#$%^()]{1,25}$", limitCount: 25)
        }
    }
}
