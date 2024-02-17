# Ignite.dev Assessment

## Overview

This repository contains files for the Ignite.dev assessment.

## Prerequisites

- [Docker](https://www.docker.com/)
- [Kind](https://kind.sigs.k8s.io/)
- [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [Docker Hub Account](https://hub.docker.com/)
- [Terraform](https://www.terraform.io/)
- [Helm](https://helm.sh/)

## Steps

### Clone the Repository

To clone the repository, run the following command:

```sh
git clone https://github.com/funkycadet/ignitedotdev-devops-task.git
```

After cloning the repository, navigate to the directory:

```sh
cd ignitedotdev-devops-task
```

### Install Kind

In your terminal, execute the following command:

```sh
./install_kind.sh
```

The script would install Docker, Kubectl and Kind, if they are not available on your system. It would also create a Kubernetes cluster using Kind.

Optional: If you would like to setup the Kubernetes Dashboard on your Kind cluster so as to have a visual access of your cluster, you can follow the steps in this blog [post](https://medium.com/@munza/local-kubernetes-with-kind-helm-dashboard-41152e4b3b3d)

### Deploy the Application

To deploy the application, run the following command:

```sh
cd deployments

terraform apply
```

The command would deploy the application to the Kubernetes cluster.

## Accessing the Application

To access the application, run the following command:

```sh
kubectl port-forward service/express-hello-world-app 3000:3000
```

The application would be accessible at `http://localhost:3000`.