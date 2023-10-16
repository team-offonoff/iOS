//
//  Dependency-SPM.swift
//  Config
//
//  Created by sejin on 2022/10/02.
//

import ProjectDescription

public extension TargetDependency {
    enum SPM {}
//    enum Carthage {}
}

public extension TargetDependency.SPM {
    static let SnapKit = TargetDependency.external(name: "SnapKit")
    static let KakaoSDKCommon = TargetDependency.external(name: "KakaoSDKCommon")
    static let KakaoSDKAuth = TargetDependency.external(name: "KakaoSDKAuth")
    static let KakaoSDKUser = TargetDependency.external(name: "KakaoSDKUser")
}

//public extension TargetDependency.Carthage {
//    static let Sentry = TargetDependency.external(name: "Sentry")
//}
