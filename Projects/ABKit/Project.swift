import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "ABKit",
    targets: [.dynamicFramework],
    externalDependencies: [
        .core
    ]
)
