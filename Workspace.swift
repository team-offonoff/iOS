import ProjectDescription
import EnvironmentPlugin

let workspace = Workspace(
    name: Environment.workspaceName,
    projects: [
        "Projects/**"
    ]
)
