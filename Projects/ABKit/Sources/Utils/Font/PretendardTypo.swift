//
//  PretendardTypo.swift
//  ABKit
//
//  Created by 박소윤 on 2023/09/26.
//  Copyright © 2023 AB. All rights reserved.
//

import UIKit
import Foundation

public enum Pretendard {
    public static let regular14: TypoCase = Regular14()
    public static let semibold14: TypoCase = SemiBold14()
    public static let regular15: TypoCase = Regular15()
    public static let bold15: TypoCase = Bold15()
    public static let regular18: TypoCase = Regular18()
    public static let bold18: TypoCase = Bold18()
    public static let regular20: TypoCase = Regular20()
    public static let semibold20: TypoCase = SemiBold20()
    public static let semibold24: TypoCase = SemiBold24()
    public static let bold24: TypoCase = Bold24()
}

extension Pretendard{
    
    //MARK: - Regular
    
    struct Regular14: TypoCase {
        let font: UIFont = ABKitFontFamily.Pretendard.regular.font(size: 14)
        let lineHeight: CGFloat? = 28
    }
    
    struct Regular15: TypoCase {
        let font: UIFont = ABKitFontFamily.Pretendard.regular.font(size: 15)
        let lineHeight: CGFloat? = nil
    }
    
    struct Regular18: TypoCase {
        let font: UIFont = ABKitFontFamily.Pretendard.regular.font(size: 18)
        let lineHeight: CGFloat? = nil
    }
    
    struct Regular20: TypoCase {
        let font: UIFont = ABKitFontFamily.Pretendard.regular.font(size: 20)
        let lineHeight: CGFloat? = nil
    }
    
    //MARK: - Bold
    
    struct Bold15: TypoCase {
        let font: UIFont = ABKitFontFamily.Pretendard.bold.font(size: 15)
        let lineHeight: CGFloat? = nil
    }
    
    struct Bold18: TypoCase {
        let font: UIFont = ABKitFontFamily.Pretendard.bold.font(size: 18)
        let lineHeight: CGFloat? = nil
    }
    
    struct Bold24: TypoCase {
        let font: UIFont = ABKitFontFamily.Pretendard.bold.font(size: 24)
        let lineHeight: CGFloat? = nil
    }
    
    //MARK: - Semibold
    
    struct SemiBold14: TypoCase {
        let font: UIFont = ABKitFontFamily.Pretendard.semiBold.font(size: 14)
        let lineHeight: CGFloat? = nil
    }
    
    struct SemiBold20: TypoCase {
        let font: UIFont = ABKitFontFamily.Pretendard.semiBold.font(size: 20)
        let lineHeight: CGFloat? = 28
    }
    
    struct SemiBold24: TypoCase {
        let font: UIFont = ABKitFontFamily.Pretendard.semiBold.font(size: 24)
        let lineHeight: CGFloat? = 33.6
    }
}
