import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "OnboardingFeature",
    targets: [.unitTest, .staticFramework, .demo, .interface],
    interfaceDependencies: [
        .Features.FeatureDependency
    ]
)
