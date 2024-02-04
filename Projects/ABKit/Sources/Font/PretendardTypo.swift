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

    public static let regular12: TypoCase = Regular12()
    public static let regular13: TypoCase = Regular13()
    public static let regular14: TypoCase = Regular14()
    public static let regular15: TypoCase = Regular15()
    public static let regular16: TypoCase = Regular16()
    public static let regular18: TypoCase = Regular18()
    public static let regular20: TypoCase = Regular20()

    public static let medium15: TypoCase = Medium15()
    public static let medium16: TypoCase = Medium16()
    public static let medium18: TypoCase = Medium18()

    public static let bold15: TypoCase = Bold15()
    public static let bold16: TypoCase = Bold16()
    public static let bold18: TypoCase = Bold18()
    public static let bold24: TypoCase = Bold24()

    public static let semibold13: TypoCase = SemiBold13()
    public static let semibold14: TypoCase = SemiBold14()
    public static let semibold16: TypoCase = SemiBold16()
    public static let semibold18: TypoCase = SemiBold18()
    public static let semibold20: TypoCase = SemiBold20()
    public static let semibold22: TypoCase = SemiBold22()
    public static let semibold24: TypoCase = SemiBold24()

    public static let black100: TypoCase = Black100()
    public static let black128: TypoCase = Black128()
    public static let black180: TypoCase = Black180()
    public static let black200: TypoCase = Black200()
}

extension Pretendard{
    
    //MARK: - Regular
    
    struct Regular12: TypoCase {
        let font: UIFont = ABKitFontFamily.Pretendard.regular.font(size: 12)
        let lineHeight: CGFloat? = 16.8
    }
    
    struct Regular13: TypoCase {
        let font: UIFont = ABKitFontFamily.Pretendard.regular.font(size: 13)
        let lineHeight: CGFloat? = 18.2
    }
    
    struct Regular14: TypoCase {
        let font: UIFont = ABKitFontFamily.Pretendard.regular.font(size: 14)
        let lineHeight: CGFloat? = nil
    }
    
    struct Regular15: TypoCase {
        let font: UIFont = ABKitFontFamily.Pretendard.regular.font(size: 15)
        let lineHeight: CGFloat? = nil
    }
    
    struct Regular16: TypoCase {
        let font: UIFont = ABKitFontFamily.Pretendard.regular.font(size: 16)
        let lineHeight: CGFloat? = 22.4
    }
    
    struct Regular18: TypoCase {
        let font: UIFont = ABKitFontFamily.Pretendard.regular.font(size: 18)
        let lineHeight: CGFloat? = nil
    }
    
    struct Regular20: TypoCase {
        let font: UIFont = ABKitFontFamily.Pretendard.regular.font(size: 20)
        let lineHeight: CGFloat? = nil
    }
    
    //MARK: - Medium
    
    struct Medium15: TypoCase {
        let font: UIFont = ABKitFontFamily.Pretendard.medium.font(size: 15)
        let lineHeight: CGFloat? = 21
    }
    
    struct Medium16: TypoCase {
        let font: UIFont = ABKitFontFamily.Pretendard.medium.font(size: 16)
        let lineHeight: CGFloat? = 22.4
    }
    
    struct Medium18: TypoCase {
        let font: UIFont = ABKitFontFamily.Pretendard.medium.font(size: 18)
        let lineHeight: CGFloat? = 25.2
    }
    
    //MARK: - Bold
    
    struct Bold15: TypoCase {
        let font: UIFont = ABKitFontFamily.Pretendard.bold.font(size: 15)
        let lineHeight: CGFloat? = nil
    }
    
    struct Bold16: TypoCase {
        let font: UIFont = ABKitFontFamily.Pretendard.bold.font(size: 16)
        let lineHeight: CGFloat? = 22.4
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
    
    struct SemiBold13: TypoCase {
        let font: UIFont = ABKitFontFamily.Pretendard.semiBold.font(size: 13)
        let lineHeight: CGFloat? = 18.2
    }
    
    struct SemiBold14: TypoCase {
        let font: UIFont = ABKitFontFamily.Pretendard.semiBold.font(size: 14)
        let lineHeight: CGFloat? = nil
    }
    
    struct SemiBold16: TypoCase {
        let font: UIFont = ABKitFontFamily.Pretendard.semiBold.font(size: 16)
        let lineHeight: CGFloat? = nil
    }
    
    struct SemiBold18: TypoCase {
        let font: UIFont = ABKitFontFamily.Pretendard.semiBold.font(size: 18)
        let lineHeight: CGFloat? = 25.2
    }
    
    struct SemiBold20: TypoCase {
        let font: UIFont = ABKitFontFamily.Pretendard.semiBold.font(size: 20)
        let lineHeight: CGFloat? = 28
    }
    
    struct SemiBold22: TypoCase {
        let font: UIFont = ABKitFontFamily.Pretendard.semiBold.font(size: 22)
        let lineHeight: CGFloat? = 30.8
    }
    
    struct SemiBold24: TypoCase {
        let font: UIFont = ABKitFontFamily.Pretendard.semiBold.font(size: 24)
        let lineHeight: CGFloat? = 33.6
    }
    
    //MARK: - Black
    
    struct Black100: TypoCase {
        let font: UIFont = ABKitFontFamily.Pretendard.black.font(size: 100)
        let lineHeight: CGFloat? = 20
    }
    
    struct Black128: TypoCase {
        let font: UIFont = ABKitFontFamily.Pretendard.black.font(size: 128)
        let lineHeight: CGFloat? = 25.6
    }
    
    struct Black180: TypoCase {
        let font: UIFont = ABKitFontFamily.Pretendard.black.font(size: 180)
        let lineHeight: CGFloat? = 36
    }
    
    struct Black200: TypoCase {
        let font: UIFont = ABKitFontFamily.Pretendard.black.font(size: 200)
        let lineHeight: CGFloat? = 280
    }
}
