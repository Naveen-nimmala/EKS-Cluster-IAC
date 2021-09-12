# unset errexit option as we want to HANDLE the 'terraform fmt' error with proper error messages instead of exiting upon facing an error
set +o errexit

RED_COLOR='\033[1;31m'
NO_COLOR='\033[0m'

# check terraform format
echo -e $RED_COLOR
terraform fmt -recursive -check -diff
if [ ! $? -eq 0 ]; then
  echo -e "\nFailed 'terraform fmt -recursive'\n"
  exit 9
fi
echo -e $NO_COLOR

# set back errexit option
set -o errexit
