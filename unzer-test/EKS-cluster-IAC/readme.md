# Start by **FORK**-ing this repo

1. Fork the repository
   1. press the **Fork** button from above.
   2. select **DevOps** folder
   3. the proejct will be forked
   4. after forking is complete, you will land inside the forked project
2. First check up
   1. notice from the URL (or breadcrumb) above that you are now in **DevOps** folder and not in **DevOps / IAC** folder
   2. we will be transferring our repo to **DevOps / IAC** folder in the following steps
   3. start by navigating to **Settings > General** of the newly forked projet
3. Change the Project name
   1. type a new **Project name**. Eg: "format", "bigredemption", "oms", "payment" etc
   2. change the **Project description** - the one from spearhead project is not relevant anymore for this project
   3. click the **Save changes** button
4. Change the Project path
   1. scroll down to the **Advanced** section and expand it
   2. scroll down to the **Change Path** section
   3. select a new path for this project. Eg: "format-iac", "bigredemption-iac", "oms-iac", "payment-iac" etc
   4. click **Change path** button
5. Transfer the project to DevOps / IAC folder
   1. scroll down to the **Advanced** section and expand it
   2. scroll down to the **Transfer project** section
   3. select a new namespace to **DEVOPS / IAC** 
      * all IAC projects are expected to be inside this folder
   4. click **Transfer project** button and fill up the form to confirm
6. Remove fork relationship with the spearhead project
   1. scroll down to the **Advanced** section and expand it
   2. scroll down to the **Remove fork relationship** section
      * check that it currently has a fork relationship to the spearhead project
   3. click **Remove fork relationship** button and fill up the form to confirm
7. Final check up
   1. your new project's IAC repo has now been **renamed & moved** correctly to the **DevOps / IAC** folder
      * check the URL / breadcrumb above
   2. it does not have any fork relationship with spearhead project

Follow the remaining instructions from the newly forked project.

---

# Directory Structure

```
blueprint  <-- the base architecture of this project
env        <-- contains variations of the base architecture for specific environments
  - dev      <-- development variation
  - stg      <-- staging variation
  - ppd      <-- pre-production variation
  - prd      <-- production variation
scripts    <-- contains scripts used for CI/CD pipelines
```

---

# Pre-Requisites before setting up

1. Follow the **README** of the [**tf_prereq_builder**](https://gitlab.airasiatech.com/devops/iac/tf_prereq_builder) repository
2. You will need 2 values from the project after the prereq is complete:
   * the **email address** of the TF Owner ServiceAccount
   * the **JSON Key** of the TF Executor ServiceAccount

---

# Setup

This repo is infra as code (IAC) for a sample project. There are few minimum places which need to be changed to apply this IAC for your new project.

1. the **GitLab environments** of the new GitLab repository
2. the **environment variables** in GitLab CI/CD pipeline settings
3. the **envs/&lt;ENV&gt;/main.tf** file(s)

### 1. The "_**GitLab environments**_" of the new GitLab repository

1. Select **Operations > Environments** from the left-panel of the GitLab repository
2. Create **New Environment** with the following values:
   1. `dev` - for development environment
   2. `stg` - for staging environment
   3. `ppd` - for pre-production environment
   4. `prd` - for production environment
4. You may not need to create all 4 - depending on the requirements of your project
5. However, you must use the values exactly as `dev`, `stg`, `ppd`, `prd` as there are dependencies on them in the later steps

### 2. The "_**environment variables**_" in GitLab CI/CD pipeline:

These are the sensitive information that we do not want to commit into our source codes. Visit **Settings > CI/CD > Variables** from the left panel to define these values.

Make sure that the variables are:
* declared for **each** of the _"Environment scope"_ defined earlier
* **must not** be defined for the _"All (default)"_ environment scope - as, otherwise, it will cause undesired conflicts

#### `     TF_EXECUTOR_SA_KEY     `

The contents of these variables should be the _**JSON Key**_ of the project's _**TF Executor**_ ServiceAccount. We obtained it in the [Pre-Requisites](#pre-requisites-before-setting-up) earlier. **NEVER COMMIT** this key into Git source control in any way.

> In Gitlab, declare this environment variable type as **FILE**. 

#### `     TF_OWNER_SA_EMAIL     `

The contents of these variables should be the _**email address**_ of the project's _**TF Owner**_ ServiceAccount. We obtained it in the [Pre-Requisites](#pre-requisites-before-setting-up) earlier. **NEVER COMMIT** this string into Git source control in any way.

> In Gitlab, declare this environment variable type as **VAR** and check **MASKED** to `true`. 

### 3. The `/envs/<ENV>/main.tf` file(s)

where **&lt;env&gt;** can be either of _DEV, STG, PPD, PRD_.

The argument/param values in these files will be specific to the environment of the project and, hence, will certainly vary from environment to environment. Pay attention to the values of `bucket`, `gcp_project_id`, `terraform_owner_email`

### 4. Remove the word `costly` from your code

The `"costly"` notation has been used to control the lifecycle of expensive resources in our spearhead project.  We don't want these resources to be running at all times - except only when we experiment with them. The `create_costly_resources` boolean helps us achieve that. In your forked repo, however, you should not have any reference to the word `costly` because your resources should be running at all times.

Remove **ANY** reference **ANY** occurrance **ANY** mention **ANY** if-else condition **ANY** string **ANY** variable that is related to the word `costly` by **ANY** means from the code of your forked repo - just a gentle reminder 😇

### 5. Remove the word `spearhead` from your code

The `spearhead` project & its resources are created only as examples. We don't want `spearhead` resources in our forked repo which is meant for actual business.

Remove **ANY** reference **ANY** occurrance **ANY** mention **ANY** if-else condition **ANY** string **ANY** variable that is related to the word `spearhead` by **ANY** means from the code of your forked repo - just a gentle reminder 😇

---

# Commit, Push, Run the CI/CD pipeline

1. Once done with the steps above, commit the repository, and push to GitLab

2. In GitLab repo, go to CI/CD pipelines and trigger the desired stages to let the actual provisioning begin

3. Any pipelines triggered on `dev`, `stg`, `ppd` or `prd` get applied only on that particular environment

---

# Running `terraform` locally

You are advised to run terraform operations via GitLab pipelines only. However, in certain cases, you might find benefit in running these operations from your local development machine.. To do that, use `docker-compose`.

1. This will provide you with a safe isolated environment to run `terraform` commands from your local machine without interfering with any of your existing GCloud credentials that you may have already setup in your local machine.

2. Check to the contents of [docker-compose.yml](https://gitlab.airasiatech.com/devops/iac/aaset-spearhead/-/blob/master/docker-compose.yml) file for reference

3. Refer to the comments of [docker-vars-dev.env.tmplt](https://gitlab.airasiatech.com/devops/iac/aaset-spearhead/-/blob/master/docker-vars-dev.env.tmplt) file for setup

### Running `terraform plan` locally

1. Run `docker-compose run pipeline`
   * that's it

### Running `terraform apply` locally

1. You are advised to perform `terraform apply` only from GitLab CI/CD pipelines and not from your local machines 😇
2. However, if you must, override your `docker-comopse` command with the [terraform_apply.sh](https://gitlab.airasiatech.com/devops/iac/aaset-spearhead/-/blob/master/scripts/terraform_apply.sh) script like following:
   * `docker-compose run pipeline ./scripts/terraform_apply.sh`
3. Note that you must `plan` the changes for an environment before you can `apply` the changes for that environment

### Running `terraform` for `stg` / `ppd` / `prd` environments locally

1. You are advised to modify `stg` / `ppd` / `prd` environments only from GitLab CI/CD pipelines and not from your local machines 😇
2. However, if you must, replace the value of the `env_file` variable in the [docker-compose.yml](https://gitlab.airasiatech.com/devops/iac/aaset-spearhead/-/blob/master/docker-compose.yml) file with the correct `.env` file
   * refer to the comments in [docker-vars-dev.env.tmplt](https://gitlab.airasiatech.com/devops/iac/aaset-spearhead/-/blob/master/docker-vars-dev.env.tmplt) file for guidance
3. Then run the following commands as necessary:
   * run `docker-compose run pipeline` to plan
   * run `docker-compose run pipeline ./scripts/terraform_apply.sh` to apply

### Running Terraform operations (eg: `state mv`, `refresh` etc) locally

1. One easy way would be to modify the [terraform_plan.sh](https://gitlab.airasiatech.com/devops/iac/aaset-spearhead/-/blob/master/scripts/terraform_plan.sh) script, and add terraform commands **BEFORE** the `terraform plan` command.
   * **DO NOT COMMIT** these changes into the source code as it is for temporary use only
2. Then, run `docker-compose run pipeline` to execute that script
3. Do this **ONLY IF** you are sure about the impacts involved in running the command

---

# FAQ - Frequently asked questions

## 1. Resolving `compute.images.get` permission error (if any)

Detailed instructions availble in [README](https://gitlab.airasiatech.com/devops/iac/tf_prereq_builder#resolving-computeimagesget-permission-error) of the `tf_prereq_builder` repository

## 2. Resolving `gcloud.services.enable` permission error (if any)

Detailed instructions availble in [README](https://gitlab.airasiatech.com/devops/iac/tf_prereq_builder#resolving-gcloudservicesenable-permission-error) of the `tf_prereq_builder` repository

## 3. Why have we used `impersonation` for running terraform?

It's a better security practice and meets compliance guidelines. Detailed explanation availabe in [this medium article](https://syedrakib.medium.com/terraform-on-gcp-impersonating-with-limited-access-on-serviceaccount-9dae6e2be11c)
