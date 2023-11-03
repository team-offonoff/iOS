//
//  DefaultLoginViewModel.swift
//  OnboardingFeatureDemo
//
//  Created by 박소윤 on 2023/10/12.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import KakaoSDKUser
import AuthenticationServices
import OnboardingFeatureInterface
import Domain
import Combine

final class DefaultLoginViewModel: LoginViewModel {
    
    @Published private var kakaoUser: User?
    
    private let loginUseCase: any LoginUseCase
    
    init(
        loginUseCase: any LoginUseCase = DefaultLoginUseCase()
    ){
        self.loginUseCase = loginUseCase
        bind()
    }
    
    private func bind(){
//        $kakaoUser
    
    }
    
    //MARK: Kakao Login
    
    func startKakaoLogin() {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    print("loginWithKakaoTalk() success.")
                    self.requestKakaoUserInformation()
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    print("loginWithKakaoAccount() success.")
                    self.requestKakaoUserInformation()
                }
            }
        }
    }
    
    private func requestKakaoUserInformation(){
        UserApi.shared.me() { (user, error) in
            if let error = error {
                print(error)
            } else {
                if let user = user {
                    let scopes = self.makeKakaoRequestScopes(user: user)
                    if scopes.count > 0 {
                        print("사용자에게 추가 동의를 받아야 합니다.")
                        //scope 목록을 전달하여 카카오 로그인 요청
                        UserApi.shared.loginWithKakaoAccount(scopes: scopes) { (_, error) in
                            if let error = error {
                                print(error)
                            } else {
                                UserApi.shared.me() { (user, error) in
                                    if let error = error {
                                        print(error)
                                    } else {
                                        print("me() success.")
                                        self.kakaoUser = user
                                    }
                                }
                            }
                        }
                    } else {
                        print("사용자의 추가 동의가 필요하지 않습니다.")
                        self.kakaoUser = user
                    }
                }
            }
        }
    }
    
    private func makeKakaoRequestScopes(user: User) -> [String] {
        var scopes = [String]()
        
//        if (user.kakaoAccount?.profileNeedsAgreement == true) { scopes.append("profile") }
//        if (user.kakaoAccount?.emailNeedsAgreement == true) { scopes.append("account_email") }
//        if (user.kakaoAccount?.birthdayNeedsAgreement == true) { scopes.append("birthday") }
//        if (user.kakaoAccount?.birthyearNeedsAgreement == true) { scopes.append("birthyear") }
//        if (user.kakaoAccount?.genderNeedsAgreement == true) { scopes.append("gender") }
//        if (user.kakaoAccount?.phoneNumberNeedsAgreement == true) { scopes.append("phone_number") }
//        if (user.kakaoAccount?.ageRangeNeedsAgreement == true) { scopes.append("age_range") }
//        if (user.kakaoAccount?.ciNeedsAgreement == true) { scopes.append("account_ci") }
        
        return scopes
    }
    
    //MARK: Apple Login
    
    func makeAppleRequest() -> ASAuthorizationAppleIDRequest {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        return request
    }
    
    func startAppleLogin(credential: ASAuthorizationAppleIDCredential) {
        
        guard let authorizationCodeData = credential.authorizationCode,
              let authorizationCode = String(data: authorizationCodeData, encoding: .utf8),
              let identityTokenData = credential.identityToken,
              let identityToken = String(data: identityTokenData, encoding: .ascii),
              let email = credential.email,
              let name = credential.fullName
        else { return }
        
        let userIdentifier = credential.user
        let userName = "\(name.familyName!)\(name.givenName!)"
    }
}
