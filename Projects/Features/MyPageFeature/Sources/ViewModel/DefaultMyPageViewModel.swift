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
    
    let profileImage: CurrentValueSubject<Any?, Never> = CurrentValueSubject(nil)
    let successDelete: PassthroughSubject<Void, Never> = PassthroughSubject()
    let errorHandler: PassthroughSubject<ErrorContent, Never> = PassthroughSubject()
    
    //MARK: Input
    
    func deleteImage() {
        successDelete.send(())
        profileImage.send(nil)
    }
    
    func modifyImage(_ image: UIImage) {
        Task {
            await modifyProfileImageUseCase.execute(request: image)
                .sink{ [weak self] result in
                    if result.isSuccess { //, let urlString = result.data, let url = URL(string: urlString) {
//                        self?.profileImage.send(url)
                        self?.profileImage.send(image)
                    }
                    else if let error = result.error {
                        self?.errorHandler.send(error)
                    }
                }
                .store(in: &cancellable)
        }
    }
    
    func logout() {
        
    }
}
