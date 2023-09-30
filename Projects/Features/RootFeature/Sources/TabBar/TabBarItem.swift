//
//  TabBarItem.swift
//  RootFeature
//
//  Created by 박소윤 on 2023/09/25.
//  Copyright © 2023 AB. All rights reserved.
//

import UIKit
import ABKit

enum TabBarItem: Int, CaseIterable {
    case home = 0
    case ab
    case new
    case user
}

extension TabBarItem {
    
    var icon: UIImage {
        switch self {
        case .home:         return Image.tabHome
        case .ab:           return Image.tabAb
        case .new:          return Image.tabNew
        case .user:         return Image.tabUser
        }
    }
    
    public func asTabBarItem() -> UITabBarItem {
        UITabBarItem(title: nil, image: icon, selectedImage: icon)
    }
}
