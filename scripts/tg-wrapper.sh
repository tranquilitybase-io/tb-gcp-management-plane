#!/bin/bash

set -euo pipefail

if [ -z "$1" ]
  then
    echo "No argument supplied"
    exit 1
fi

cd deployment
terragrunt init
terragrunt run-all $1 --terragrunt-non-interactive