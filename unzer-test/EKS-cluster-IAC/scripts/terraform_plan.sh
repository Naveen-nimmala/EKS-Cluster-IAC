# exit script upon any non-zero exit code
set -o errexit

source ./scripts/prepare_terraform.sh

# Remove any previous plan file (if exists)
[ -f "tf_plan" ] && rm "tf_plan"

# Plan Infrastructure
terraform plan -out "tf_plan" \
  # -target="module.${ENV}_infra"
