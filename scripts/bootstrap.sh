#!/bin/bash

if [ -z "$1" ]
  then
    echo "No argument supplied"
    exit 1
fi

case $1 in
  'init')
    cd ./bootstrap
    terraform init
    ;;

  'plan')
    cd ./bootstrap
    terraform plan
    ;;

  'apply')
    cd ./bootstrap
    terraform apply -auto-approve
    ;;
esac

echo "Bootstrap apply completed successfully"
