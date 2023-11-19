//
//  LoginViewModel.swift
//  FeatureDependency
//
//  Created by 박소윤 on 2023/10/12.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import KakaoSDKAuth
import KakaoSDKUser
import AuthenticationServices
import Combine

public protocol KakaoLoginDelegate {
    func startKakaoLogin()
}

public protocol AppleLoginDelegate {
    func startAppleLogin(credential:ASAuthorizationAppleIDCredential)
    func makeAppleRequests() -> [ASAuthorizationAppleIDRequest]
}

public protocol LoginViewModelInput: KakaoLoginDelegate, AppleLoginDelegate {

}

public protocol LoginViewModelOutput {
    var moveHome: PassthroughSubject<Void, Never> { get }
    var moveSignUp: PassthroughSubject<Void, Never> { get }
}

public protocol LoginViewModel: LoginViewModelInput, LoginViewModelOutput {

}
