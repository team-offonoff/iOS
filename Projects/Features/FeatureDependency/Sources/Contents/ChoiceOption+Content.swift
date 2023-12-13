//
//  ChoiceOption+Contentable.swift
//  FeatureDependency
//
//  Created by 박소윤 on 2023/12/12.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import Domain

extension ChoiceTemp.Option {
    public var content: ChoiceOptionContent {
        switch self {
        case .A:        return AChoiceOptionContent()
        case .B:        return BChoiceOptionContent()
        }
    }
}

public protocol ChoiceOptionContent {
    var title: String { get }
    var color: UIColor { get }
    var corenrMask: CACornerMask { get }
    var gradientLayer: CAGradientLayer { get}
}

public struct AChoiceOptionContent: ChoiceOptionContent {
    public let title: String = "A"
    public let color: UIColor = Color.mainA
    public let corenrMask: CACornerMask = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
    public let gradientLayer: CAGradientLayer = .generate(startX: 1, endX: 0, color: Color.mainA)
}

public struct BChoiceOptionContent: ChoiceOptionContent {
    public let title: String = "B"
    public let color: UIColor = Color.mainB
    public let corenrMask: CACornerMask = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
    public let gradientLayer: CAGradientLayer = .generate(startX: 0, endX: 1, color: Color.mainB)
}

private extension CAGradientLayer {
    static func generate(startX: CGFloat, endX: CGFloat, color: UIColor) -> CAGradientLayer {
        let layer0 = CAGradientLayer()
        layer0.colors = [
            color.cgColor,
            color.withAlphaComponent(0).cgColor
        ]
        layer0.locations = [0.5, 1]
        layer0.startPoint = CGPoint(x: startX, y: 0.5)
        layer0.endPoint = CGPoint(x: endX, y: 0.5)
        return layer0
    }
}
