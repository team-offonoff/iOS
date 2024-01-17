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

public typealias MyPageViewModel = MyPageViewModelInput & MyPageViewModelOutput & DeleteProfileImageViewModel

public protocol MyPageViewModelInput {
    func modifyImage(_ image: UIImage)
    func logout()
}

public protocol MyPageViewModelOutput {
    var profileImage: PassthroughSubject<URL?, Never> { get }
}

public protocol DeleteProfileImageViewModel {
    var successDelete: PassthroughSubject<Void, Never> { get }
    func deleteImage()
}
