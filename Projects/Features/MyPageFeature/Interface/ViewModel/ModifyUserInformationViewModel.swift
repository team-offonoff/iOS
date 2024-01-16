//
//  ModifyUserInformationViewModel.swift
//  MyPageFeatureInterface
//
//  Created by 박소윤 on 2024/01/15.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import Combine
import UIKit
import Domain

public typealias ModifyUserInformationViewModel = ModifyUserInformationViewModelInput & ModifyUserInformationViewModelOutput

public protocol ModifyUserInformationViewModelInput {
    var jobSubject: PassthroughSubject<Job, Never> { get }
}

public protocol ModifyUserInformationViewModelOutput {
    var jobSubject: PassthroughSubject<Job, Never> { get }
}
