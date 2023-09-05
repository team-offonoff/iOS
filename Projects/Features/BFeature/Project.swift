import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "BFeature",
    targets: [.unitTest, .staticFramework, .demo],
    internalDependencies: [
        .Features.FeatureDependency
    ]
)
