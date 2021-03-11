#!/bin/bash

#set -euo pipefail

cd bootstrap
terraform fmt -recursive

cd deployment
terragrunt hclfmt