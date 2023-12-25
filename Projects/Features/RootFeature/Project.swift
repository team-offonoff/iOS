import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "RootFeature",
    targets: [.unitTest, .staticFramework],
    internalDependencies: [
        .Features.Home.Feature,
        .Features.Topic.Feature,
        .Features.Onboarding.Feature
    ]
)

