variable "AZURE_SUBSCRIPTION_ID" {}
variable "AZURE_CLIENT_ID" {}
variable "AZURE_TENANT_ID" {}
variable "AZURE_CLIENT_SECRET" {}
variable "AZURE_LOCATION" {}

variable "LINUX_WORKER_NIC_CONFIG_NAMES" {
  type = "list"
  default = ["lindcrworker1-nic-config", "lindcrworker2-nic-config"]
}

variable "WINDOWS_WORKER_NIC_CONFIG_NAMES" {
  type = "list"
  default = ["windcrworker1-nic-config", "windcrworker2-nic-config"]
}
variable "DOCKER_EE_URL" {}
variable "DOCKER_EE_VERSION" {}
variable "DOCKER_EE_RELEASE" {}

variable "DOCKER_STORAGE_ACCOUNT" {}
variable "DOCKER_RESOURCE_GROUP" {}

variable "DOCKER_SERVER_USER" {}
variable "DOCKER_SERVER_PASSWORD" {}
variable "PATH_TO_PRIVATE_KEY" {}
variable "PATH_TO_PUBLIC_KEY" {}


variable "DOCKER_ADMIN_USER" {}
variable "DOCKER_ADMIN_PASSWORD" {}
variable "DOCKER_UCP_VERSION" {}

variable "KUBERNETES_VERSION" {}

variable "DOCKER_UCP_PORT" {}


variable "ALLOWED_PORTS" {
  type = "list"
  default = ["22", "3389", "5985", "5986", "80", "443", "2375", "2376", "2377", "6443", "6444", "8070-8090"]
}

variable "MY_PUBLIC_IP" {}

variable "DOCKER_UCP_FQDN" {}
variable "DOCKER_LINUXWORKER_FQDN" {}
variable "DOCKER_WINDOWSWORKER_FQDN" {}

variable "DOCKER_VNET_NAME" {}
variable "DOCKER_SUBNET_NAME" {}
variable "DOCKER_NSG_NAME" {}

variable "DOCKER_SUBNET" {}
variable "DOCKER_VNET" {}
