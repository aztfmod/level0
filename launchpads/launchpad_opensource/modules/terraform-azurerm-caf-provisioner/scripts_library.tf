locals {
    scripts = {
        install_docker = {
            centos = "install_docker.sh"
            windows = "install_docker.ps1"
        }

        devops_self_hosted_container = {
            Docker = "devops_agent.Dockerfile"
        }
    }
}