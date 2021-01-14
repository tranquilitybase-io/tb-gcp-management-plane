#!/bin/bash

#install terragrunt
wget https://github.com/gruntwork-io/terragrunt/releases/download/v0.27.0/terragrunt_linux_amd64
chmod u+x terragrunt_linux_amd64
mv terragrunt_linux_amd64 terragrunt
sudo mv terragrunt /usr/local/bin/terragrunt
sudo terragrunt --version

#install terraform
wget https://releases.hashicorp.com/terraform/0.13.4/terraform_0.13.4_linux_amd64.zip
unzip terraform_0.13.4_linux_amd64.zip
sudo mv ./terraform /usr/local/bin/
rm terraform_0.13.4_linux_amd64.zip
terraform --version