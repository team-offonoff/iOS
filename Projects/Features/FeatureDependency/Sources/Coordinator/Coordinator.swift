//
//  Coordinator.swift
//  FeatureDependency
//
//  Created by 박소윤 on 2023/10/26.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit

public protocol Coordinator: AnyObject {
    init(window: UIWindow?)
    func start()
}

extension Coordinator {
    public var sceneDelegate: UISceneDelegate? {
        UIApplication.shared.connectedScenes.first?.delegate
    }
}
