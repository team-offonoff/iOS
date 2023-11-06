import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "FeatureDependency",
    targets: [.dynamicFramework],
    internalDependencies: [
        .data,
        .abKit
    ]
)
