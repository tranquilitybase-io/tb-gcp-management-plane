#!/bin/bash

# install terraform/terragrunt

./scripts/setup.sh

cd ./bootstrap
terraform init
terraform plan

echo "Bootstrap apply completed successfully"
