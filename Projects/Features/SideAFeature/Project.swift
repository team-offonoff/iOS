import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "SideAFeature",
    targets: [.unitTest, .staticFramework, .demo, .interface],
    interfaceDependencies: [.Features.Topic.Feature]
)
