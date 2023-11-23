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
                                    guard let oauthToken = oauthToken, let user = user else { return }
                                    print("me() success.")
                                    self.kakaoUser = (oauthToken, user)
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
