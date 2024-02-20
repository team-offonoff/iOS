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
    
    init(
        fetchProfileUseCase: any FetchProfileUseCase,
        modifyProfileImageUseCase: any ModifyProfileImageUseCase,
        deleteProfileImageUseCase: any DeleteProfileImageUseCase
    ) {
        self.fetchProfileUseCase = fetchProfileUseCase
        self.modifyProfileImageUseCase = modifyProfileImageUseCase
        self.deleteProfileImageUseCase = deleteProfileImageUseCase
    }
    
    private let fetchProfileUseCase: any FetchProfileUseCase
    private let modifyProfileImageUseCase: any ModifyProfileImageUseCase
    private let deleteProfileImageUseCase: any DeleteProfileImageUseCase
    
    //MARK: Output
    
    var profile: Profile?
    let profileImage: CurrentValueSubject<Any?, Never> = CurrentValueSubject(nil)
    let successFetchProfile: PassthroughSubject<Void, Never> = PassthroughSubject()
    let successDelete: PassthroughSubject<Void, Never> = PassthroughSubject()
    let errorHandler: PassthroughSubject<ErrorContent, Never> = PassthroughSubject()
    
    //MARK: Input
    
    func fetchProfile() {
        fetchProfileUseCase.execute()
            .sink{ [weak self] result in
                if result.isSuccess, let profile = result.data {
                    defer {
                        self?.successFetchProfile.send(())
                        self?.profileImage.send(profile.profileImageUrl)
                    }
                    self?.profile = .init(
                        profileImageUrl: profile.profileImageUrl,
                        nickname: profile.nickname,
                        birth: profile.birth.replacingOccurrences(of: "-", with: "/"),
                        gender: profile.gender,
                        job: profile.job
                    )
                }
                else if let error = result.error {
                    self?.errorHandler.send(error)
                }
            }
            .store(in: &cancellable)
    }
    
    
    func deleteImage() {
        deleteProfileImageUseCase.execute()
            .sink{ [weak self] result in
                if result.isSuccess {
                    self?.profileImage.send(nil)
                    self?.successDelete.send(())
                }
                else if let error = result.error {
                    self?.errorHandler.send(error)
                }
            }
            .store(in: &cancellable)
    }
    
    func modifyImage(_ image: UIImage) {
        Task {
            await modifyProfileImageUseCase.execute(request: image)
                .sink{ [weak self] result in
                    if result.isSuccess{
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
