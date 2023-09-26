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
    public static let tab_home = UIImage.load(name: "tab_home")
    public static let tab_ab = UIImage.load(name: "tab_ab")
    public static let tab_new = UIImage.load(name: "tab_new")
    public static let tab_user = UIImage.load(name: "tab_mypage")
    
    //MARK: Home
    public static let home_alarm = UIImage.load(name: "alarm_home")
}
