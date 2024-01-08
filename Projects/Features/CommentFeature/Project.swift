import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "CommentFeature",
    targets: [.unitTest, .staticFramework, .interface],
    interfaceDependencies: [
        .Features.FeatureDependency
    ]
)
