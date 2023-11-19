//
//  DefaultLoginViewModel.swift
//  OnboardingFeatureDemo
//
//  Created by 박소윤 on 2023/10/12.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import KakaoSDKUser
import KakaoSDKAuth
import AuthenticationServices
import OnboardingFeatureInterface
import FeatureDependency
import Domain
import Combine
import Core

final class DefaultLoginViewModel: BaseViewModel, LoginViewModel {
    
    init(
        loginUseCase: any LoginUseCase
    ){
        self.loginUseCase = loginUseCase
        super.init()
        bind()
    }
    
    let moveHome: PassthroughSubject<Void, Never> = PassthroughSubject()
    let moveSignUp: PassthroughSubject<Void, Never> = PassthroughSubject()
    
    @Published private var kakaoUser: (oauthToken: KakaoSDKAuth.OAuthToken, user: KakaoSDKUser.User)?
    
    private let loginUseCase: any LoginUseCase
    
    override func bind(){
        bindKakaoLogin()
    }
    
    private func bindKakaoLogin() {
        
        let response = $kakaoUser
            .compactMap{ $0?.oauthToken.idToken }
            .flatMap{ idToken in
                self.loginUseCase.execute(request: .init(idToken: idToken))
            }
        
        // response success
        response
            .filter{ $0.code == .success }
            .compactMap{ $0 }
            .compactMap{ $0.data }
            .sink{ [weak self] in
                
                guard let isNewMember = $0.isNewMember,
                      let accessToken = $0.accessToken else { return }
                
                UserManager.shared.accessToken = accessToken
                UserManager.shared.idToken = self?.kakaoUser?.oauthToken.idToken
                UserManager.shared.email = self?.kakaoUser?.user.kakaoAccount?.email
                
                if isNewMember {
                    self?.moveSignUp.send(())
                }
                else {
                    self?.moveHome.send(())
                }
            }
            .store(in: &cancellable)
        
        // response fail
        let failResponse = response
            .filter{ $0.code != .success }
        
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
            }
            else {
                if let user = user {
                    let scopes = makeKakaoRequestScopes(user: user)
                    if scopes.count > 0 {
                        print("사용자에게 추가 동의를 받아야 합니다.")
                        //scope 목록을 전달하여 카카오 로그인 요청
                        UserApi.shared.loginWithKakaoAccount(scopes: scopes) { (oauthToken, error) in
                            if let error = error {
                                print(error)
                            }
                            else {
                                UserApi.shared.me() { (user, error) in
                                    if let error = error {
                                        print(error)
                                    }
                                    else {
                                        print("me() success.")
                                        guard let oauthToken = oauthToken, let user = user else { return }
                                        self.kakaoUser = (oauthToken, user)
                                    }
                                }
                            }
                        }
                    }
                    /*
                     else {
                     print("사용자의 추가 동의가 필요하지 않습니다.")
                     self.kakaoUser = user
                     }
                     */
                }
            }
        }
        
        func makeKakaoRequestScopes(user: KakaoSDKUser.User) -> [String] {
            var scopes = [String]()
            if (user.kakaoAccount?.emailNeedsAgreement == true) { scopes.append("account_email") }
            return scopes
        }
    }
    
    //MARK: Apple Login
    
    func makeAppleRequests() -> [ASAuthorizationAppleIDRequest] {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.email] //애플 로그인은 이름 제외, 이메일만 동의.
        return [request]
    }
    
    func startAppleLogin(credential: ASAuthorizationAppleIDCredential) {
        
        guard let authorizationCodeData = credential.authorizationCode,
              let authorizationCode = String(data: authorizationCodeData, encoding: .utf8),
              let identityTokenData = credential.identityToken,
              let identityToken = String(data: identityTokenData, encoding: .ascii),
              let email = credential.email
//              let name = credential.fullName
        else { return }
        
        let userIdentifier = credential.user
//        let userName = "\(name.familyName!)\(name.givenName!)"
    }
}
