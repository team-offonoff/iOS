//
//  TopicContentInputTableViewCell.swift
//  TopicFeature
//
//  Created by 박소윤 on 2023/12/26.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import TopicFeatureInterface
import FeatureDependency
import Domain
import Combine

protocol ImageTextIncludeContentView: UIView {
    //타입 상관없는 publisher로 사용하는 건 어떤지
    var aTextPublisher: AnyPublisher<String, Never>? { get }
    var bTextPublisher: AnyPublisher<String, Never>? { get }
    var aImagePublisher: AnyPublisher<UIImage?, Never>? { get }
    var bImagePublisher: AnyPublisher<UIImage?, Never>? { get }
    func text(option: Choice.Option) -> String?
    func image(option: Choice.Option) -> UIImage?
}
