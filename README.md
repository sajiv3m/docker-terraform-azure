# Build Docker Enterprise 2.1 cluster on Azure using Terraform


## Overview

Files included in this repository will help you build a 5-node Docker Enterprise cluster
1. One Linux server that hosts both Docker UCP and DTR. Same node will be configured as the Swarm Manager and Kubernetes Master
2. Two Linux worker nodes in an availability set and accessed through a load balancer
3. Two Windows worker nodes in an availability set and accessed through a load balancer

## Pre-requisites to deploy this infrastructure

1. Azure subscription with access to create resources (free account will not work)
2. Docker Enterprise licence - you can get a free trial licence from [Docker Store](https://hub.docker.com/editions/enterprise/docker-ee-trial) which is valid for 30 days
3. Terraform v0.11, which you can download free from [HashiCorp site](https://www.terraform.io/downloads.html)

**The templates and scripts provided will perform a fully automated deployment of the Docker Enterprise cluster. In-depth knowledge of Terraform or scripting is not required to perform the steps**


## Steps to deploy the Docker Enterprise cluster on Azure

1. Clone the repository to your local system
2. Generate the SSH key pair files using `ssh-keygen -m PEM -f docker-key`
3. Download Docker licence key file - `docker_subscription.lic` - from Docker store and copye the file to `lin-files` folder.
4. Create Azure Service Principal to use with Terraform
   - az login
   - az account list (to see your subscriptions)
   - az account set -s "name of the subscription you want to use"
   - subscription_id="copy the id of the subscription you want to use"
   - az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/${SUBSCRIPTION_ID}"
  
    **Note the appID(CLIENT_ID), password(CLIENT_SECRET), tenant ID**


5. Update the variables in `terraform.tfvars` using the above information and as per your requirements

6. Run `terraform init` to initialise Terraform and download the required plugins
7. Run `terraform plan` to confirm there are no errors
8. Run `terraform apply` to build the infrastructure on Azure. It will take approximately 20 to 30 minutes to complete
9. Note the hostnames and IP addresses shared at the end of execution as you will need this to access the environment


## Access the Docker Enterprise cluster from your system

1. To access the Docker UCP using a browser, go to [https://FQDN-of-the-UCP-host-shown-in-terraform-output:8070](https://FQDN-of-the-UCP-host-shown-in-terraform-output:8070)
   - Ignore the certificate related warning
   - Login using the Docker admin credentials you mentioned in the `terraform.tfvars` file
   - you should see 1 Swarm manager and 4 worker nodes in Ready status

2. To access the Docker Trusted Registry (DTR), go to [https://FQDN-of-the-UCP-host-shown-in-terraform-output](https://FQDN-of-the-UCP-host-shown-in-terraform-output)
    - DTR is also installed on the same host as UCP
    - Once you login to DTR, turn on the setting `Create repository on push` by accessing `System > General > Repositories`. This will ensure repository is automatically created when you run `docker push`

3. To use Docker and Kubernetes CLI, download the client bundle
    - run the `client/download_client_bundle.sh` script
    - give admin credentials, UCP FQDN and port numbers when prompted
    - `source env.sh`
    - `docker node ls` - will show all 5 servers (1 manager, 4 worker nodes)
    - `kubectl get nodes` - will show 3 servers (excluding the Windows worker nodes which do not support Kubernetes)

Start deploying your containers on to this platform...