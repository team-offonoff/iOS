import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "TopicGenerateFeature",
    targets: [.unitTest, .staticFramework, .demo, .interface],
    interfaceDependencies: [.Features.FeatureDependency]
)
