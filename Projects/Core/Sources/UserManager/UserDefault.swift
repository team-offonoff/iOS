//
//  UserDefault.swift
//  Core
//
//  Created by 박소윤 on 2023/10/28.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

@propertyWrapper
public struct UserDefault<T> {
    
    let key: String
    let defaultValue: T

    public var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
