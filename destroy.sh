#!/bin/bash

##
# Destroy the terraform cluster 
##
cd terraform
terraform destroy -auto-approve=true -lock=false 
