# exit script upon any non-zero exit code
set -o errexit

source ./scripts/prepare_terraform.sh

# Exit script if plan file does not exist
if [ ! -f "tf_plan" ]; then
  printf "\n\n \"tf_plan\" file missing\n\n\n"
  exit 9
fi

# Print plan file
terraform show "tf_plan"

# Run TF Apply
terraform apply "tf_plan"

# Remove plan file
rm "tf_plan"
