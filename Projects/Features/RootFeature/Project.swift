import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "RootFeature",
    targets: [.staticFramework],
    internalDependencies: [
        .Features.Home.Feature,
        .Features.SideA.Feature,
        .Features.SideB.Feature,
        .Features.Onboarding.Feature,
        .Features.MyPage.Feature
    ]
)

