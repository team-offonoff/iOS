import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "SideBFeature",
    targets: [.unitTest, .staticFramework, .demo, .interface],
    interfaceDependencies: [.Features.Topic.Feature]
)
