#!/bin/bash

set -euo pipefail

TERRAFORM_VERSION=0.14.6
TERRAGRUNT_VERSION=0.28.2

if [ "$(uname)" == "Darwin" ]; then
    OSTYPE=darwin
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    OSTYPE=linux
fi

#install terragrunt
wget -O /tmp/terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_${OSTYPE}_amd64
chmod +x /tmp/terragrunt
sudo mv /tmp/terragrunt /usr/local/bin
terragrunt -version

#install terraform
wget -O /tmp/terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_${OSTYPE}_amd64.zip
unzip -q /tmp/terraform.zip -d /tmp
chmod +x /tmp/terraform
sudo mv /tmp/terraform /usr/local/bin
terraform --version
