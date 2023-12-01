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
    case aSide
    case bSide
    case user
}

extension TabBarItem {
    
    var defaultIcon: UIImage {
        switch self {
        case .home:         return Image.tabHomeDeselect
        case .aSide:        return Image.tabAb
        case .bSide:        return Image.tabNew
        case .user:         return Image.tabMyDeselect
        }
    }
    
    var selectedIcon: UIImage {
        switch self {
        case .home:         return Image.tabHomeSelect
        case .aSide:        return Image.tabAb
        case .bSide:        return Image.tabNew
        case .user:         return Image.tabMySelect
        }
    }
    
    var title: String {
        switch self {
        case .home:         return "홈"
        case .aSide:        return "A 사이드"
        case .bSide:        return "B 사이드"
        case .user:         return "MY"
        }
    }
}
