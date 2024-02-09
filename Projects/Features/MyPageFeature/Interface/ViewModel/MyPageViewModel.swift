//
//  MyPageViewModel.swift
//  MyPageFeatureInterface
//
//  Created by 박소윤 on 2024/01/16.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import Combine
import UIKit
import FeatureDependency

public typealias MyPageViewModel = MyPageViewModelInput & MyPageViewModelOutput & DeleteProfileImageViewModel & ErrorHandleable

public protocol MyPageViewModelInput {
    func modifyImage(_ image: UIImage)
    func logout()
}

public protocol MyPageViewModelOutput {
    var profileImage: CurrentValueSubject<Any?, Never> { get }
}

public protocol DeleteProfileImageViewModel {
    var successDelete: PassthroughSubject<Void, Never> { get }
    func deleteImage()
}
