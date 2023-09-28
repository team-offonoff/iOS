//
//  PretendardTypo.swift
//  ABKit
//
//  Created by 박소윤 on 2023/09/26.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

public struct Pretendard {
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

public enum FontType{
    case Black
    case Bold
    case SemiBold
    case Medium
    case Regular
}

extension Pretendard{
    
    //MARK: - Regular
    
    struct Regular14: TypoCase {
        let font: FontType = .Regular
        let size: CGFloat = 14
        let lineHeight: CGFloat? = 28
    }
    
    struct Regular15: TypoCase {
        let font: FontType = .Regular
        let size: CGFloat = 15
        let lineHeight: CGFloat? = nil
    }
    
    struct Regular18: TypoCase {
        let font: FontType = .Regular
        let size: CGFloat = 18
        let lineHeight: CGFloat? = nil
    }
    
    struct Regular20: TypoCase {
        let font: FontType = .Regular
        let size: CGFloat = 20
        let lineHeight: CGFloat? = nil
    }
    
    //MARK: - Bold
    
    struct Bold15: TypoCase {
        let font: FontType = .Bold
        let size: CGFloat = 15
        let lineHeight: CGFloat? = nil
    }
    
    struct Bold18: TypoCase {
        let font: FontType = .Regular
        let size: CGFloat = 18
        let lineHeight: CGFloat? = nil
    }
    
    //MARK: - Semibold
    
    struct SemiBold14: TypoCase {
        let font: FontType = .SemiBold
        let size: CGFloat = 14
        let lineHeight: CGFloat? = nil
    }
    
    struct SemiBold20: TypoCase {
        let font: FontType = .Regular
        let size: CGFloat = 20
        let lineHeight: CGFloat? = 28
    }
    
    struct SemiBold24: TypoCase {
        let font: FontType = .Regular
        let size: CGFloat = 24
        let lineHeight: CGFloat? = 33.6
    }
    
    struct Bold24: TypoCase {
        let font: FontType = .Regular
        let size: CGFloat = 24
        let lineHeight: CGFloat? = nil
    }
}
