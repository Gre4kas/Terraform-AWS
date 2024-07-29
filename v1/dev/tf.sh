#!/bin/bash

apply () {
    cd vpc || exit
    terraform init
    terraform apply --auto-approve
    cd ../subnet || exit 
    terraform init
    terraform apply --auto-approve
}

destroy () {
    cd subnet || exit
    terraform destroy --auto-approve
    cd ../vpc || exit 
    terraform destroy --auto-approve
}

case "$1" in
    "apply") apply 
    ;;
    "destroy") destroy
    ;;
esac
