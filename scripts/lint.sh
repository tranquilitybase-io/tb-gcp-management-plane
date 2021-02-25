#!/bin/bash

set -euo pipefail

cd deployment
terraform fmt -recursive
terragrunt hclfmt