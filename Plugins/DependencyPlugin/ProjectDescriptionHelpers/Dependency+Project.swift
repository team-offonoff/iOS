//
//  Dependency+Project.swift
//  ProjectDescriptionHelpers
//
//  Created by sejin on 2022/10/02.
//

import ProjectDescription

public extension Dep {
    
    struct Features {
        public struct A {}
        public struct B {}
    }
    
    struct Modules {}
}

// MARK: - Root

public extension Dep {
    static let data = Dep.project(target: "Data", path: .data)
    static let domain = Dep.project(target: "Domain", path: .domain)
    static let core = Dep.project(target: "Core", path: .core)
    static let abKit = Dep.project(target: "ABKit", path: .abKit)
    static let thirdPartyLibs = Dep.project(target: "ThirdPartyLibs", path: .thirdPartyLibs)
}

// MARK: - Modules

public extension Dep.Modules {
    static let network = Dep.project(target: "Network", path: .relativeToModules("Network"))
}

// MARK: - Features

public extension Dep.Features {
    
    static let name = "Feature"
    
    static func project(name: String, group: String) -> Dep { .project(target: "\(group)\(name)", path: .relativeToFeature("\(group)\(name)")) }
    
    static let FeatureDependency = TargetDependency.project(target: "FeatureDependency", path: .relativeToFeature("FeatureDependency"))
    
    static let RootFeature = TargetDependency.project(target: "RootFeature", path: .relativeToFeature("RootFeature"))
}

public extension Dep.Features.A {
    static let Feature = Dep.Features.project(name: Dep.Features.name, group: "A")
}

public extension Dep.Features.B {
    static let Feature = Dep.Features.project(name: Dep.Features.name, group: "B")
}
