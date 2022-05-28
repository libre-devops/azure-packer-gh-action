#!/usr/bin/env bash

set -eou pipefail

print_success() {
    lightcyan='\033[1;36m'
    nocolor='\033[0m'
    echo -e "${lightcyan}$1${nocolor}"
}

print_error() {
    lightred='\033[1;31m'
    nocolor='\033[0m'
    echo -e "${lightred}$1${nocolor}" ; exit 1;
}

print_alert() {
    yellow='\033[1;33m'
    nocolor='\033[0m'
    echo -e "${yellow}$1${nocolor}"
}

# Prepare variables with better common names
if [[ -n "${1}" ]]; then
    packer_path="${1}" && \
        cd "${packer_path}"
else
    print_error "Code path is empty or invalid, check the following tree output and see if it is as you expect - Error - LDO_PKR_CODE_PATH" && tree . && exit 1
fi

if [[ -n "${2}" ]]; then
    packer_client_id="${2}"
else
    print_error "Variable assignment for resource group failed or is invalid, ensure it is correct and try again - Error LDO_PKR_RG_NAME" ; exit 1
fi

if [[ -n "${3}" ]]; then
    packer_client_secret="${3}"
else
    print_error "Variable assignment for compute gallery failed or is invalid, ensure it is correct and try again - Error LDO_PKR_COMPUTE_GALLERY" ; exit 1
fi

if [[ -n "${4}" ]]; then
   packer_subscription_id="${4}"
else
    print_error "Variable assignment packer client secret failed or is invalid, ensure it is correct and try again - Error LDO_PKR_CLIENT_SECRET" ; exit 1
fi

if [[ -n "${5}" ]]; then
    packer_tenant_id="${5}"
else
    print_error "Variable assignment for packer client id failed or is invalid, ensure it is correct and try again - Error LDO_PKR_CLIENT_ID" ; exit 1
fi

if [[ -n "${6}" ]]; then
    packer_version="${6}"
    tfenv install "${packer_version}" && tfenv use "${packer_version}"
else
    print_alert "Packer Version is empty, by default, this pipeline will use the latest if it is set as empty, otherwise, you must specify a canonical type version. Error code - LDO_TF_TERRAFORM_VERSION"
    pkenv install latest && pkenv use latest
fi

export PKR_VAR_client_id="${packer_client_id}"
export PKR_VAR_client_secret="${packer_client_secret}"
export PKR_VAR_subscription_id="${packer_subscription_id}"
export PKR_VAR_tenant_id="${packer_tenant_id}"

packer fmt -recursive ${packer_path} -diff && \
packer build "${packer_path}"

