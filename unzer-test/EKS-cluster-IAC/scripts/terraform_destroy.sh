# exit script upon any non-zero exit code
set -o errexit

source ./scripts/prepare_terraform.sh

# Destroy Infrastructure
terraform plan -destroy -out "tf_destroy_plan"
terraform apply "tf_destroy_plan"
rm "tf_destroy_plan"
