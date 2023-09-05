import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "RootFeature",
    targets: [.unitTest, .staticFramework],
    internalDependencies: [
        .Features.A.Feature,
        .Features.B.Feature
    ]
)

