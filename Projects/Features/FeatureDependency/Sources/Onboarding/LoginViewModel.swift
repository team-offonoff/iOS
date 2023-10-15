//
//  LoginViewModel.swift
//  FeatureDependency
//
//  Created by 박소윤 on 2023/10/12.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import AuthenticationServices

public protocol LoginViewModel {
    func startKakaoLogin()
    func startAppleLogin(credential:ASAuthorizationAppleIDCredential)
    func makeAppleRequest() -> ASAuthorizationAppleIDRequest
}
