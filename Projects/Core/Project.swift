import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "Core",
    targets: [.dynamicFramework],
    internalDependencies: [
        .thirdPartyLibs
    ]
)
