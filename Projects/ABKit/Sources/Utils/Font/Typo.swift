//
//  Typo.swift
//  ABKit
//
//  Created by 박소윤 on 2023/09/26.
//  Copyright © 2023 AB. All rights reserved.
//

import UIKit

public struct Typo{
    
    public enum FontFamily {
        case pretendard
        case monteserrat
    }

    public enum FontType {
        case regular
        case medium
        case bold
        case semibold
        case black
    }

    public static func font(family: FontFamily, type: FontType, size: CGFloat) -> UIFont {
        let fontConvertible: ABKitFontConvertible = {
            switch family {
            case .pretendard:       return pretendardFont(type: type)
            case .monteserrat:      return montserratFont(type: type)
            }
        }()
        return fontConvertible.font(size: size)
    }
    
    private static func pretendardFont(type: FontType) -> ABKitFontConvertible{
        switch type {
        case .regular:      return ABKitFontFamily.Pretendard.regular
        case .medium:      return ABKitFontFamily.Pretendard.medium
        case .bold:         return ABKitFontFamily.Pretendard.bold
        case .semibold:     return ABKitFontFamily.Pretendard.semiBold
        case .black:     return ABKitFontFamily.Pretendard.black
        }
    }
    
    private static func montserratFont(type: FontType) -> ABKitFontConvertible{
        switch type {
        case .medium:       return ABKitFontFamily.Montserrat.medium
        default:            fatalError()
        }
    }
}
