# Build Docker Enterprise 2.1 cluster on Azure using Terraform


## Overview

Files included in this repository will help you build a 5-node Docker Enterprise cluster
1. One Linux server that hosts both Docker UCP and Docker Trusted Registry (DTR). Same node will also be configured as the Swarm Manager and Kubernetes Master
2. Two Linux worker nodes in an availability set, which will be automatically joined as worker nodes to the Docker Swarm created by the UCP host
3. Two Windows worker nodes in an availability set, which will be automatically joined as worker nodes to the Docker Swarm created by the UCP host

## Pre-requisites to deploy this infrastructure

1. Microsoft Azure account with access to create resources (free account will not work)
2. Docker Enterprise licence - you can get a free trial licence from [Docker Store](https://hub.docker.com/editions/enterprise/docker-ee-trial) which is valid for 30 days
3. Terraform v0.11, which you can download free from [HashiCorp site](https://www.terraform.io/downloads.html)

**The templates and scripts provided will perform a fully automated deployment of the Docker Enterprise cluster. In-depth knowledge of Terraform or scripting is not required to perform the steps**

**Steps given in the next section are to be performed from your Laptop running MacOS or Linux. If it is a Windows Laptop, please install [GitBash](https://gitforwindows.org/)**

## Steps to deploy the Docker Enterprise cluster on Azure

1. Clone the repository to your local system
2. Goto the folder where the files are saved
3. Update values in `terraform.tfvars` using the information from the following steps
   - Create Azure Service Principal to use with Terraform. If you don't have Azure CLI installed on your Laptop, execute the following the Cloud shell which you can access from the Azure portal
        > az login
        > az account list (to see your subscriptions)
        > az account set -s "name of the subscription you want to use"
        > subscription_id="copy the id of the subscription you want to use"
        > az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/${SUBSCRIPTION_ID}"
        **Note the appID(CLIENT_ID), password(CLIENT_SECRET), tenant ID**
    - Run `curl -s ifconfig.me` or goto [https://www.whatismyip.com](https://www.whatismyip.com) to note your public IP. This is the value for `MY_PUBLIC_IP`
    - Go to Docker Store and copy the License URL. This is the value for `DOCKER_EE_URL`
    - Generate the SSH key pair files using `ssh-keygen -m PEM -f docker-key`



4. Download Docker licence key file - `docker_subscription.lic` - from Docker store and copy the file to `lin-files` folder. Existing empty `docker_subscription.lic` file can be replaced with your copy.

5. Check `terraform` that you downloaded is in your PATH and that you have the latest version.
    - execute `terraform version`. It should show `Terraform v0.11.11` or latest.
6.  Execute the following Terraform commands to build the Docker cluster defined in the `.tf` files
    - Run `terraform init` - this will initialize Terraform and download the required plugins
    - Run `terraform plan` to confirm there are no errors
    - Run `terraform apply` to build the infrastructure. It will take approximately 30 minutes to complete.


**Note the hostnames and IP addresses shared at the end of execution as you will need this to access the environment**


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