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

public final class DefaultLoginViewModel: BaseViewModel, LoginViewModel {
    
    init(
        loginUseCase: any LoginUseCase
    ){
        self.loginUseCase = loginUseCase
        super.init()
    }
    
    public var moveHome: (() -> Void)?
    public var moveSignUp: (() -> Void)?
    
    @Published private var kakaoUser: (oauthToken: KakaoSDKAuth.OAuthToken?, user: KakaoSDKUser.User?) = (nil, nil)
    public let errorHandler: PassthroughSubject<ErrorContent, Never> = PassthroughSubject()
    private let loginUseCase: any LoginUseCase
    
    public override func bind(){
        bindKakaoLogin()
    }
    
    private func bindKakaoLogin() {
        
        let response = $kakaoUser
            .filter{
                $0.oauthToken != nil && $0.user != nil
            }
            .compactMap{
                $0.oauthToken?.idToken
            }
            .flatMap{ idToken in
                self.loginUseCase.execute(request: .init(idToken: idToken))
            }
            .share()
        
        response
            .sink{ [weak self] result in
                
                guard let self = self else { return }
                
                if result.isSuccess, let data = result.data {
                    
                    UserManager.shared.accessToken = data.accessToken
                    UserManager.shared.memberId = data.memberId
                    
                    switch data.joinStatus {
                    case .authRegistered:
                        // 회원 정보 입력 페이지로 이동
                        self.moveSignUp?()
                    case .personalRegistered:
                        // 약관 동의 페이지로 이동
                        break
                    case .complete:
                        // 홈 화면으로 이동
                        self.moveHome?()
                    default:
                        return
                    }
                }
                else if let error = result.error {
                    self.errorHandler.send(error)
                }
            }
            .store(in: &cancellable)
    }
    
    //MARK: Kakao Login
    
    public func startKakaoLogin() {
        
        if UserApi.isKakaoTalkLoginAvailable() {
            loginWithKakaoTalk()
        }
        else {
            loginWithKakaoAccount()
        }
        
        //MARK: Helper method
        
        func loginWithKakaoTalk() {
            UserApi.shared.loginWithKakaoTalk(completion: loginCompletion(_:_:))
        }
        
        func loginWithKakaoAccount() {
            UserApi.shared.loginWithKakaoAccount(completion: loginCompletion(_:_:))
        }
        
        func loginCompletion(_ oauthToken: OAuthToken?, _ error: Error?) {
            if let error = error {
                print(error)
            } else {
                if let oauthToken = oauthToken {
                    kakaoUser.oauthToken = oauthToken
                }
                userInformation()
            }
        }
        
        func userInformation() {
            
            UserApi.shared.me() { (user, error) in
                
                if let error = error {
                    print(error)
                }
                else {
                    loginWithRequestScope()
                }
                
                func loginWithRequestScope() {
                    UserApi.shared.loginWithKakaoAccount(scopes: requestScopes()) { (oauthToken, error) in
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
                                    guard let user = user else { return }
                                    self.kakaoUser.user = user
                                }
                            }
                        }
                    }
                }
                
                func requestScopes() -> [String] {
                    var scopes = [String]()
                    if (user?.kakaoAccount?.emailNeedsAgreement == true) { scopes.append("account_email") }
                    return scopes
                }
            }
        }
    }
    
    //MARK: Apple Login
    
    public func makeAppleRequests() -> [ASAuthorizationAppleIDRequest] {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.email] //애플 로그인은 이름 제외, 이메일만 동의.
        return [request]
    }
    
    public func startAppleLogin(credential: ASAuthorizationAppleIDCredential) {
        
        guard let authorizationCodeData = credential.authorizationCode,
              let authorizationCode = String(data: authorizationCodeData, encoding: .utf8),
              let identityTokenData = credential.identityToken,
              let identityToken = String(data: identityTokenData, encoding: .ascii),
              let email = credential.email
        else { return }
        
        let userIdentifier = credential.user
    }
}
