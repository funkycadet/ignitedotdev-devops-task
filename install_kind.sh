#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$@" > /dev/null 2>&1
}

# Variable to detect the OS
OS="$(uname)"
USER=$(whoami) # Get the current user

# Install Docker if it is not installed
if ! command_exists docker; then
    echo "Docker not found, installing..."

    case $OS in
    Linux)
        # Installation commands for Docker on Linux
        sudo apt-get update
        sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
        sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
        sudo apt-get update
        sudo apt-get install -y docker-ce

        # Add the current user to the Docker group
        sudo usermod -aG docker $USER
        echo "You may need to log out and log back in for group changes to take effect."
        ;;
    Darwin)
        # Assuming brew is installed; install Docker for Mac
        brew cask install docker
        # Open Docker app to complete the setup - might require manual intervention
        open /Applications/Docker.app
        ;;
    *)
        echo "Unsupported operating system for Docker installation: $OS"
        exit 1
        ;;
    esac
else
    echo "Docker is already installed."
fi

# Install kubectl if it is not installed
if ! command_exists kubectl; then
    echo "kubectl not found, installing..."

    case $OS in
    Linux)
        sudo apt-get update && sudo apt-get install -y apt-transport-https gnupg2
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
        chmod +x ./kubectl
        sudo mv ./kubectl /usr/local/bin/kubectl
        ;;
    Darwin)
        brew install kubectl || brew link --overwrite kubernetes-cli
        ;;
    *)
        echo "Unsupported operating system: $OS"
        exit 1
        ;;
    esac
else
    echo "kubectl is already installed."
fi

# Install kind if it is not installed
if ! command_exists kind; then
    echo "Installing kind..."
    case $OS in
    Linux)
        curl -Lo ./kind "https://kind.sigs.k8s.io/dl/v0.11.1/kind-linux-amd64"
        chmod +x ./kind
        sudo mv ./kind /usr/local/bin/kind
        ;;
    Darwin)
        ARCH=$(uname -m)
        if [[ $ARCH == "x86_64" ]]; then
            curl -Lo ./kind "https://kind.sigs.k8s.io/dl/v0.11.1/kind-darwin-amd64"
        elif [[ $ARCH == "arm64" ]]; then
            curl -Lo ./kind "https://kind.sigs.k8s.io/dl/v0.11.1/kind-darwin-arm64"
        else
            echo "Unsupported architecture: $ARCH"
            exit 1
        fi
        chmod +x ./kind
        sudo mv ./kind /usr/local/bin/kind
        ;;
    *)
        echo "Unsupported operating system for kind installation: $OS"
        exit 1
        ;;
    esac
else
    echo "kind is already installed."
fi

# Create a kind cluster
kind create cluster --name ignitedotdev-cluster

echo "Kind cluster has been created successfully."
