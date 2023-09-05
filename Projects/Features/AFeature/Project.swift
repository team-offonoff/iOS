import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "AFeature",
    targets: [.unitTest, .staticFramework, .demo],
    internalDependencies: [
        .Features.FeatureDependency
    ]
)
