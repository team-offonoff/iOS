import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "RootFeature",
    targets: [.staticFramework],
    internalDependencies: [
        .Features.Home.Feature,
        .Features.Onboarding.Feature
    ]
)

