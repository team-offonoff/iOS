//
//  Color.swift
//  ABKit
//
//  Created by 박소윤 on 2023/09/25.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit

public extension UIColor{
    
    convenience init(_ value: CGFloat){
        self.init(r: value, g: value, b: value, alpha: 1)
    }
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat){
        self.init(r: r, g: g, b: b, alpha: 1)
    }
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat){
        self.init(red: r/255, green: g/255, blue: b/255, alpha: alpha)
    }
}

public struct Color{
    
    public static let homeBackground = UIColor(r: 36, g: 32, b: 54, alpha: 1)
    
    public static let subPurple = UIColor(r: 164, g: 111, b: 243)
    public static let subNavy2 = UIColor(r: 60, g: 52, b: 87)
    
    public static let transparent = UIColor.white.withAlphaComponent(0)
    
    public static let white = UIColor.white
    public static let white40 = white.withAlphaComponent(0.4)
    public static let white60 = white.withAlphaComponent(0.6)
    public static let white80 = white.withAlphaComponent(0.8)
    
    public static let black = UIColor.black
    public static let black20 = black.withAlphaComponent(0.2)
}
