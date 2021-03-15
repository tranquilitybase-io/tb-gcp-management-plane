#!/bin/bash

set -e

URL=$2

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

function destroy() {
    cd ./bootstrap || exit
    terraform destroy
}

function apply() {
    cd ./bootstrap || exit
    terraform apply -auto-approve
    echo "Bootstrap apply completed successfully"
}

function push-gsr() {
    export GCLOUD_EMAIL=$(gcloud config get-value account)
    export USER_NAME=$(gcloud config get-value account | cut -d @ -f1)
    echo "$GCLOUD_EMAIL"
    echo "$USER_NAME"

    git config --global user.email "$GCLOUD_EMAIL"
    git config --global user.name "$USER_NAME"

    git config --global credential.https://source.developers.google.com.helper gcloud.sh
    git remote set-url origin ${URL}

    if [ -n "$(git status --porcelain)" ]; then
    echo "Commiting changes."
    git add .
    git commit -m "Author: $(git log --format='%an <%ae>' -n 1 HEAD)"
    git push origin master --tags
    else
    echo "No changes commited."
    fi
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

  'destroy')
    destroy
    ;;

  'push-gsr')
    push-gsr ${URL}
    ;;
esac