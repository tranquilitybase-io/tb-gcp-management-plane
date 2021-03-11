#!/bin/bash

function init() {
    cd ./bootstrap || exit
    terraform init
}

function validate() {
    cd ./bootstrap || exit
    terraform validate
}

function plan() {
    cd ./bootstrap || exit
    terraform plan
}

function apply() {
    cd ./bootstrap || exit
    terraform apply -auto-approve
    echo "Bootstrap apply completed successfully"
}

function push-gsr() {
    export GCLOUD_EMAIL=$(gcloud config get-value account)
    echo "$GCLOUD_EMAIL"
    echo "$USER"

    git config --global user.email "$GCLOUD_EMAIL"
    git config --global user.name "$USER"

    git config credential.helper gcloud.sh
    git remote set-url gsr "$2"
    git add .
    git commit -m "Author: $(git log --format='%an <%ae>' -n 1 HEAD)"
    git push gsr master
}

###
# Main script
###

if [ -z "$1" ]
  then
    echo "No argument supplied"
    exit 1
fi

case $1 in
  'init')
    init
    ;;

  'validate')
    validate
    ;;

  'plan')
    plan
    ;;

  'apply')
    apply
    ;;

  'push-gsr')
    push-gsr "$2"
    ;;
esac