# values of few variables modified with value replace-this  and also commented
# if you are giving values in this file, remove comments else Terraform will ask during runtime
# you may also change other values as per your requirements

# AZURE_SUBSCRIPTION_ID = "replace-this"
# AZURE_CLIENT_ID = "replace-this"
# AZURE_CLIENT_SECRET = "replace-this"
# AZURE_TENANT_ID = "replace-this"

# AZURE_LOCATION = "replace-this"
# DOCKER_STORAGE_ACCOUNT = "replace-this"
# DOCKER_RESOURCE_GROUP = "replace-this"
# DOCKER_VNET_NAME = "replace-this"
# DOCKER_SUBNET_NAME = "replace-this"
# DOCKER_NSG_NAME = "replace-this"

DOCKER_VNET = "10.0.0.0/16"
DOCKER_SUBNET = "10.0.1.0/24"


# DOCKER_EE_URL = "replace this with the licence URL from Docker store"

DOCKER_EE_VERSION = "18.09"
DOCKER_EE_RELEASE = "5:18.09.0~3-0~ubuntu-xenial"

# DOCKER_SERVER_USER = "replace-this"
# DOCKER_SERVER_PASSWORD = "replace-this"

PATH_TO_PRIVATE_KEY = "docker-key"
PATH_TO_PUBLIC_KEY = "docker-key.pub"

DOCKER_ADMIN_USER = "admin"
# DOCKER_ADMIN_PASSWORD = "replace-this"

DOCKER_UCP_VERSION = "3.1.3"
KUBERNETES_VERSION = "1.11.5"
DOCKER_UCP_PORT = "8070"

# find your public IP using the command curl -qs http://ifconfig.me
# MY_PUBLIC_IP = "replace-this"

# DOCKER_UCP_FQDN = "replace-this"
# DOCKER_LINUXWORKER_FQDN = "replace-this"
# DOCKER_WINDOWSWORKER_FQDN = "replace-this"
