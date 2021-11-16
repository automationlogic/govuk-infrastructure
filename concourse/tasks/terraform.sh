#!/bin/sh
#
# terraform.sh runs Terraform from the directory $DEPLOYMENT_PATH, acting as
# the IAM role specified in $ASSUME_ROLE_ARN. All args are passed through to
# Terraform (plus some extra ones for convenience).

set -u

auto_approve=""
var_file_args="-var-file ../variables/${ENVIRONMENT}/common.tfvars \
  -var-file ../variables/common.tfvars"
tf_action="${1:-}" && shift
case $tf_action in
    apply | destroy )
        auto_approve="-input=false -auto-approve"
        ;;
    plan | import )
        auto_approve="-input=false"
        ;;
    state )
        var_file_args=""
esac

# Assume role once here, rather than configuring the same thing (via different
# options) in each Terraform provider in every root module.
#
# TODO: Consider factoring this out into a script and including it in the image.
creds="$(aws sts assume-role \
  --role-session-name "concourse-$(date +%d-%m-%y_%H-%M-%S)" \
  --role-arn "${ASSUME_ROLE_ARN}" \
  | jq .Credentials)"
AWS_ACCESS_KEY_ID="$(echo "$creds" | jq -r .AccessKeyId)"
AWS_SECRET_ACCESS_KEY="$(echo "$creds" | jq -r .SecretAccessKey)"
AWS_SESSION_TOKEN="$(echo "$creds" | jq -r .SessionToken)"
export AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN

set -x
export TF_IN_AUTOMATION=1
cd "${DEPLOYMENT_PATH}"
terraform init -input=false -backend-config "${ENVIRONMENT}.backend"
terraform state list
terraform show
terraform state show eks
terraform "$tf_action" "$var_file_args" $auto_approve "$@"
