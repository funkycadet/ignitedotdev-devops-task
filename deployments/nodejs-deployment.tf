terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.13.1"
    }
  }
}

provider "kubectl" {
  # Configuration for the kubectl provider
  # If needed, configure the provider to point to the correct kubeconfig file or context
}

resource "kubectl_manifest" "example" {
  yaml_body = file("${path.module}/nodejs-deployment.yaml")
}
