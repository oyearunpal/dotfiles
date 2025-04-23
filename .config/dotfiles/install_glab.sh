#!/bin/bash

# Default glab version and download URL
GLAB_VERSION="v1.48.0"
# GLAB_URL="https://gitlab.com/gitlab-org/cli/-/releases/${GLAB_VERSION}/downloads/glab_${GLAB_VERSION#v}_linux_amd64.tar.gz"

# Function to install glab on Linux
install_glab_linux() {
  echo "Installing glab on Linux..."
  GLAB_VERSION=$1
  # Download and extract
  GLAB_URL="https://gitlab.com/gitlab-org/cli/-/releases/${GLAB_VERSION}/downloads/glab_${GLAB_VERSION#v}_linux_amd64.tar.gz"
  echo $GLAB_URL
  curl -L $GLAB_URL -o glab.tar.gz
  tar -xvzf glab.tar.gz
  sudo mv bin/glab /usr/local/bin/
  rm glab.tar.gz
}

# Function to install glab on macOS using Homebrew
install_glab_mac() {
  echo "Installing glab on macOS..."
  # Use Homebrew to install glab
  brew install glab
}

# Function to check for updates and upgrade glab on Linux
upgrade_glab_linux() {
  echo "Checking for glab updates..."

   # Check for updates using glab check-update
  UPDATE_OUTPUT=$(glab check-update 2>&1)

  if [ -z "$UPDATE_OUTPUT" ]; then
    echo "No updates available for glab."
  else
    # Extract the download URL and version from the check-update output
    DOWNLOAD_URL=$(echo "$UPDATE_OUTPUT" | awk 'NR==2{print $0}')
    VERSION=$(echo "$DOWNLOAD_URL" | awk -F'/' '{print $NF}')



    echo "Update available: $VERSION. Upgrading glab..."
    install_glab_linux $VERSION
  fi
}

# Function to upgrade glab on macOS using Homebrew
upgrade_glab_mac() {
  echo "Upgrading glab on macOS..."
  # Use Homebrew to upgrade glab
  brew upgrade glab
}

# Check for OS type (Linux or macOS)
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  # Linux systems
  if command -v glab &> /dev/null; then
    echo "glab is already installed. Checking for updates..."
    upgrade_glab_linux
  else
    echo "glab is not installed. Installing..."
    install_glab_linux $GLAB_VERSION
  fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS systems
  if command -v glab &> /dev/null; then
    echo "glab is already installed. Checking for updates..."
    upgrade_glab_mac
  else
    echo "glab is not installed. Installing..."
    install_glab_mac
  fi
else
  echo "Unsupported operating system. This script supports only Unix-based systems (Linux/macOS)."
  exit 1
fi

# Verify the installation or upgrade
if command -v glab &> /dev/null; then
  echo "glab installation or upgrade successful!"
  glab --version
else
  echo "glab installation or upgrade failed. Please check for errors above."
fi

