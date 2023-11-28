//
//  Image.swift
//  ABKit
//
//  Created by 박소윤 on 2023/09/25.
//  Copyright © 2023 AB. All rights reserved.
//

import UIKit

extension UIImage{
    static func load(name: String) -> UIImage {
        UIImage(named: name, in: ABKit.bundle, compatibleWith: nil)!
    }
}

public struct Image{
    //MARK: Tab
    public static let tabHome = UIImage.load(name: "tab_home")
    public static let tabAb = UIImage.load(name: "tab_ab")
    public static let tabNew = UIImage.load(name: "tab_new")
    public static let tabUser = UIImage.load(name: "tab_mypage")
    
    //MARK: Home
    public static let slide = UIImage.load(name: "slide")
    public static let dot = UIImage.load(name: "dot")
    public static let homeArrow = UIImage.load(name: "home_arrow")
    public static let homeAlarmOn = UIImage.load(name: "home_alarm_on")
    public static let homeAlarmOff = UIImage.load(name: "home_alarm_off")
}
