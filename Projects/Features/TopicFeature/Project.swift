import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "TopicFeature",
    targets: [.unitTest, .dynamicFramework, .demo, .interface],
    interfaceDependencies: [.Features.Comment.Feature]
)
