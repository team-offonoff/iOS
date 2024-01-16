//
//  DefaultModifyUserInformationViewModel.swift
//  MyPageFeature
//
//  Created by 박소윤 on 2024/01/15.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit
import Combine
import MyPageFeatureInterface
import FeatureDependency
import Domain

final class DefaultModifyUserInformationViewModel: BaseViewModel, ModifyUserInformationViewModel {
    
    let jobSubject: PassthroughSubject<Job, Never> = PassthroughSubject()
    
}
