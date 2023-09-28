//
//  HeaderViewProtocol.swift
//  ABKit
//
//  Created by 박소윤 on 2023/09/28.
//  Copyright © 2023 AB. All rights reserved.
//

import UIKit

public protocol Navigatable{
    var popButton: UIButton { get }
}

public protocol HeaderTouchable{
    var rightItem: UIButton { get }
}
