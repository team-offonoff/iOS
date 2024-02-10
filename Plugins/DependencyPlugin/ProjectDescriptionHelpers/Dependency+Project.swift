import ProjectDescription

public extension Dep {
    
    struct Features {
        public struct Onboarding {}
        public struct Home {}
        public struct SideA {}
        public struct SideB {}
        public struct Topic {}
        public struct TopicGenerate {}
        public struct Comment {}
        public struct MyPage {}
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

public extension Dep.Features.Onboarding {
    static let Feature = Dep.Features.project(name: Dep.Features.name, group: "Onboarding")
}

public extension Dep.Features.Home {
    static let Feature = Dep.Features.project(name: Dep.Features.name, group: "Home")
}

public extension Dep.Features.Topic {
    static let Feature = Dep.Features.project(name: Dep.Features.name, group: "Topic")
}

public extension Dep.Features.TopicGenerate {
    static let Feature = Dep.Features.project(name: Dep.Features.name, group: "TopicGenerate")
}

public extension Dep.Features.SideA {
    static let Feature = Dep.Features.project(name: Dep.Features.name, group: "SideA")
}

public extension Dep.Features.SideB {
    static let Feature = Dep.Features.project(name: Dep.Features.name, group: "SideB")
}

public extension Dep.Features.Comment {
    static let Feature = Dep.Features.project(name: Dep.Features.name, group: "Comment")
}

public extension Dep.Features.MyPage {
    static let Feature = Dep.Features.project(name: Dep.Features.name, group: "MyPage")
}
