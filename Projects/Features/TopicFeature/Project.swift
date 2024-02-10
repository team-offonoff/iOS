import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "TopicFeature",
    targets: [.unitTest, .staticFramework, .interface],
    interfaceDependencies: [
        .Features.Comment.Feature
    ]
)
