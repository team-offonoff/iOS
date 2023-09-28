//
//  Typo.swift
//  ABKit
//
//  Created by 박소윤 on 2023/09/26.
//  Copyright © 2023 AB. All rights reserved.
//

import UIKit

public struct Typo{
    //기본 - Pretendard
    public static func font(type: FontType, size: CGFloat) -> UIFont{
        guard let font = UIFont(name: "Pretendard-\(type)", size: size) else {
            return UIFont()
        }
        return font
    }
    
    public static func font(type: TypoCase) -> UIFont{
        guard let font = UIFont(name: "Pretendard-\(type.font)", size: type.size) else {
            return UIFont()
        }
        return font
    }
}
