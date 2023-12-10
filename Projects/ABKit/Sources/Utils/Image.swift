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
    public static let tabHomeSelect = UIImage.load(name: "tab_home_select")
    public static let tabHomeDeselect = UIImage.load(name: "tab_home_deselect")
    public static let tabAb = UIImage.load(name: "tab_ab")
    public static let tabNew = UIImage.load(name: "tab_new")
    public static let tabMySelect = UIImage.load(name: "tab_my_select")
    public static let tabMyDeselect = UIImage.load(name: "tab_my_deselect")
    public static let tabGenerateTopic = UIImage.load(name: "tab_generate_topic")
    
    //MARK: Home
    
    public static let chatLike = UIImage.load(name: "chat_like")
    public static let chatDislike = UIImage.load(name: "chat_dislike")
    public static let close = UIImage.load(name: "close")
    public static let choiceTextExpand = UIImage.load(name: "choice_text_expand")
    public static let choiceImageExpand = UIImage.load(name: "choice_image_expand")
    public static let hide = UIImage.load(name: "hide")
    public static let report = UIImage.load(name: "report")
    public static let resetEnable = UIImage.load(name: "reset_enable")
    public static let resetDisable = UIImage.load(name: "reset_disable")
    public static let slide = UIImage.load(name: "slide")
    public static let dot = UIImage.load(name: "dot")
    public static let homeArrow = UIImage.load(name: "home_arrow")
    public static let homeAlarmOn = UIImage.load(name: "home_alarm_on")
    public static let homeAlarmOff = UIImage.load(name: "home_alarm_off")
}
