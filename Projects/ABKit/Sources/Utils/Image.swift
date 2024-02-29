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
    
    public static let down = UIImage.load(name: "down")
    public static let back = UIImage.load(name: "back")
    public static let exit = UIImage.load(name: "exit")
    public static let dropdown = UIImage.load(name: "dropdown")
    
    public static let checkbox = UIImage.load(name: "checkbox")
    public static let checkboxFill = UIImage.load(name: "checkbox_fill")
    
    public static let modifyProfileImage = UIImage.load(name: "modify_profile_image")
    public static let takePicture = UIImage.load(name: "take_picture")
    public static let gallery = UIImage.load(name: "gallery")
    
    public static let sideAHeader = UIImage.load(name: "side_a_header")
    public static let sideBHeader = UIImage.load(name: "side_b_header")
    
    public static let sideAbackground = UIImage.load(name: "side_a_background")
    public static let sideBbackground = UIImage.load(name: "side_b_background")
    
    public static let profilePlaceholder = UIImage.load(name: "profile_placeholder")
    
    public static let winnerCrown = UIImage.load(name: "winner_crown")
    public static let winMark = UIImage.load(name: "win_mark")
    public static let loseMark = UIImage.load(name: "lose_mark")
    
    //MARK: Alarm
    public static let alarmChat = UIImage.load(name: "alarm_chat")
    public static let alarmCount = UIImage.load(name: "alarm_count")
    public static let alarmLike = UIImage.load(name: "alarm_like")
    public static let alarmTimer = UIImage.load(name: "alarm_timer")
    
    
    //MARK: Login
    
    public static let logo = UIImage.load(name: "logo")
    public static let loginApple = UIImage.load(name: "login_apple")
    public static let loginKakao = UIImage.load(name: "login_kakao")
    
    //MARK: Tab
    public static let tabHomeSelect = UIImage.load(name: "tab_home_select")
    public static let tabHomeDeselect = UIImage.load(name: "tab_home_deselect")
    public static let tabAb = UIImage.load(name: "tab_ab")
    public static let tabNew = UIImage.load(name: "tab_new")
    public static let tabMySelect = UIImage.load(name: "tab_my_select")
    public static let tabMyDeselect = UIImage.load(name: "tab_my_deselect")
    public static let tabGenerateTopic = UIImage.load(name: "tab_generate_topic")
    
    //MARK: BottomSheet
    
    public static let modify = UIImage.load(name: "modify")
    public static let delete = UIImage.load(name: "delete")
    public static let hide = UIImage.load(name: "hide")
    public static let report = UIImage.load(name: "report")
    public static let resetEnable = UIImage.load(name: "reset_enable")
    public static let resetDisable = UIImage.load(name: "reset_disable")
    
    //MARK: Comment
    public static let comment = UIImage.load(name: "comment")
    public static let chatLike = UIImage.load(name: "chat_like")
    public static let chatDislike = UIImage.load(name: "chat_dislike")
    public static let chatLikeActivate = UIImage.load(name: "chat_like_activate")
    public static let chatDislikeActivate = UIImage.load(name: "chat_dislike_activate")
    public static let sendEnabled = UIImage.load(name: "send_enabled")
    public static let sendDisabled = UIImage.load(name: "send_disabled")
    
    //MARK: Home

    public static let imageExpandDismiss = UIImage.load(name: "image_expand_dismiss")
    public static let textExpand = UIImage.load(name: "text_expand")
    public static let imageExpand = UIImage.load(name: "image_expand")
    public static let slide = UIImage.load(name: "slide")
    public static let more = UIImage.load(name: "more")
    public static let next = UIImage.load(name: "next")
    public static let alarmOn = UIImage.load(name: "alarm_on")
    public static let alarm = UIImage.load(name: "alarm")
    
    //MARK: Topic Generate

    public static let topicGenerateNormal = UIImage.load(name: "topic_generate_normal")
    public static let topicGenerateChoiceA = UIImage.load(name: "topic_generate_a")
    public static let topicGenerateChoiceB = UIImage.load(name: "topic_generate_b")
    public static let topicGenerateBottom = UIImage.load(name: "topic_generate_bottom_image")
    public static let topicGenerateArrowDown = UIImage.load(name: "topic_generate_arrow_down")
    
    public static let topicGenerateTextNoraml = UIImage.load(name: "topic_generate_text_normal")
    public static let topicGenerateTextSelected = UIImage.load(name: "topic_generate_text_selected")
    public static let topicGenerateImageNormal = UIImage.load(name: "topic_generate_image_normal")
    public static let topicGenerateImageSelected = UIImage.load(name: "topic_generate_image_selected")
    public static let topicGenerateSwitch = UIImage.load(name: "topic_generate_switch")
    public static let topicGenerateImageCancel = UIImage.load(name: "topic_generate_image_cancel")
    public static let topicGenerateHeaderArrowDown = UIImage.load(name: "topic_generate_header_arrow_down")
    public static let topicGenerateHeaderArrowUp = UIImage.load(name: "topic_generate_header_arrow_up")
}
