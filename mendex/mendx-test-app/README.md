# Test Python App

## Tools & Techs
- Cloud - GCP
- CICD - gitlab
- Orchestration - K8s (kustomize, Makefile for dynamic manifests)
- Programming - Python3.8

## Procedure 
I have added multiple extra steps in CICD like bash scripts in Makefile and kustomize patches, RollBacks etc. Just i want to make sure app deployment should have end to end process with automation, when we scale the app or any other resources, it will be easy for us to maintain entire ecosystem

### Directory Structure
    ├── Dockerfile
    ├── Makefile
    ├── README.md
    ├── app
    │   ├── app.py
    │   └── test_app.py
    ├── k8s
    │   ├── base
    │   │   ├── deployment.yml
    │   │   ├── kustomization.yml
    │   │   ├── namespace.yml
    │   │   └── service.yml
    │   └── overlays
    │       ├── dev
    │       │   ├── deployment-patch.yml
    │       │   ├── kustomization.yml
    │       │   └── namespace-patch.yml
    │       ├── ppd
    │       │   ├── deployment-patch.yml
    │       │   ├── kustomization.yml
    │       │   └── namespace-patch.yml
    │       ├── prd
    │       │   ├── deployment-patch.yaml
    │       │   ├── kustomization.yml
    │       │   └── namespace-patch.yml
    │       └── stg
    │           ├── deployment-patch.yml
    │           ├── kustomization.yml
    │           └── namespace-patch.yml
    └── requirements.txt
    

Process will start from CICD(.gitlab-ci.yml) file,

- Gitlab takes gcp-base image and start building images(Publish Image --> here we are using dind approach to build docker images, we don't require any docker image to build this) 

- It runs the Unittest while building an image, if unitest fails, it stops building an image 
- Image will be build and deploy based on branch name.
	1. If branch name is **developement** or new MR create, Image will be build and deploy in dev environment

	1. If branch name is **staging** or new MR create, Image will be build and deploy in staging environment

	1. If branch name is **master**, it builds the image and deploy in preprod environment

	1. if release **tag** creates, it builds the image and deploy in Production environment

	1. Finally we have **Rollback Stage** if anything goes wrong,  we can Rollback to previours version.

- **Dockerfile** --> will start building the image with source code(app dir) and it install the requirements while building an image, requirement file will have **hug and pytest** modules.
- Once build completed, it will try tag the image name with latest commit and it tries to push the image to private repo(Using Makefile)

- Next will start **deployment** process, It will try to run the files under **k8s/overlays/{env}**.

- Based on **env** ,kustomise will make patches under **overlays** ( It changes the replicas count and labels, deployment names, namespaces etc. ) and it goes to **base** starts executing deployment manifests.

- It finally apply the chnages on namespace, deployment and service.yml files and it uses `commonLabels --> app: test-app`

