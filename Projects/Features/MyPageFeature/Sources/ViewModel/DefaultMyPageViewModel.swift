//
//  DefaultMyPageViewModel.swift
//  MyPageFeature
//
//  Created by 박소윤 on 2024/01/16.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import MyPageFeatureInterface
import FeatureDependency
import UIKit
import Combine
import Domain

final class DefaultMyPageViewModel: BaseViewModel, MyPageViewModel {
    
    init(modifyProfileImageUseCase: any ModifyProfileImageUseCase) {
        self.modifyProfileImageUseCase = modifyProfileImageUseCase
    }
    
    private let modifyProfileImageUseCase: any ModifyProfileImageUseCase
    
    //MARK: Output
    
    let profileImage: PassthroughSubject<URL?, Never> = PassthroughSubject()
    let successDelete: PassthroughSubject<Void, Never> = PassthroughSubject()
    
    //MARK: Input
    
    func deleteImage() {
        successDelete.send(())
        profileImage.send(nil)
    }
    
    func modifyImage(_ image: UIImage) {
        Task {
            if let url = try await modifyProfileImageUseCase.execute(request: image) {
                profileImage.send(URL(string: url))
            }
            else {
                
            }
        }
    }
    
    func logout() {
        
    }
}
