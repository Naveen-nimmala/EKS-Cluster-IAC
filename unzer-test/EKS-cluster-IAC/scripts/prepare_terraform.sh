# exit script upon any non-zero exit code
set -o errexit


source ./scripts/terraform_fmt.sh

# initialize terraform
cd envs/${ENV}
terraform get
terraform init
