#!/bin/bash

set -e

pwd
source ./check_session.sh
cd ./step3-azure_devops_pipelines/

check_session

terraform init
terraform $@

