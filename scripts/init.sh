#!/usr/bin/env bash

echo "starting..."


terraform destroy --auto-approve && terraform apply -auto-approve
