//
//  Term+Content.swift
//  FeatureDependency
//
//  Created by 박소윤 on 2024/01/16.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import Domain

extension Term {
    
    public var title: String {
        switch self {
        case .serviceUse:   return "서비스 이용 약관"
        case .privacy:      return "개인정보 수집 및 이용 동의"
        case .marketing:    return "마케팅 정보 수신 동의"
        }
    }
    
    public var isEssential: Bool {
        switch self {
        case .serviceUse, .privacy:
            return true
        case .marketing:
            return false
        }
    }
}
