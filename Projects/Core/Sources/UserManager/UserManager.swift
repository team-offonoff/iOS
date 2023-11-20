//
//  UserManager.swift
//  Core
//
//  Created by 박소윤 on 2023/10/28.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

public class UserManager {
    
    public static let shared: UserManager = UserManager()
    
    private init(){ }
    
    @UserDefault(key: "accessToken", defaultValue: nil)
    public var accessToken: String?
    
    @UserDefault(key: "refreshToken", defaultValue: nil)
    public var refreshToken: String?
    
    @UserDefault(key: "email", defaultValue: nil)
    public var email: String?
    
    @UserDefault(key: "idToken", defaultValue: nil)
    public var idToken: String?
}
