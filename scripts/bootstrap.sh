#!/bin/bash

if [ -z "$1" ]
  then
    echo "No argument supplied"
    exit 1
fi

case $1 in
  'push-gsr')
    export GCLOUD_EMAIL=$(gcloud config get-value account)
    echo $GCLOUD_EMAIL
    echo $USER

    git config --global user.email "$GCLOUD_EMAIL"
    git config --global user.name "$USER"

    # gcloud source repos create $REPO
    git config credential.helper gcloud.sh
    git remote set-url gsr https://source.developers.google.com/p/tf-bootstrap-uy97x/r/tb-management-plane
    git push gsr master
    ;;

  'init')
    cd ./bootstrap
    terraform init
    ;;

  'validate')
    cd ./bootstrap
    terraform validate
    ;;

  'plan')
    cd ./bootstrap
    terraform plan
    ;;

  'apply')
    cd ./bootstrap
    terraform apply -auto-approve
    echo "Bootstrap apply completed successfully"
    ;;
esac