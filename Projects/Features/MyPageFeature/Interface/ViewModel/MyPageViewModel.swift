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
import Domain

public typealias MyPageViewModel = MyPageViewModelInput & MyPageViewModelOutput & DeleteProfileImageViewModel & ErrorHandleable

public protocol MyPageViewModelInput {
    func fetchProfile()
    func modifyImage(_ image: UIImage)
    func logout()
}

public protocol MyPageViewModelOutput {
    var successFetchProfile: PassthroughSubject<Void, Never> { get }
    var profile: Profile? { get set }
    var profileImage: CurrentValueSubject<Any?, Never> { get }
}

public protocol DeleteProfileImageViewModel {
    var successDelete: PassthroughSubject<Void, Never> { get }
    func deleteImage()
}
