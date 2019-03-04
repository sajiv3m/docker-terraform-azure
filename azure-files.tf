resource "local_file" "azure_json" {
    filename = "${path.module}/lin-files/azure.json"
    content = <<EOF1
{
    "cloud":"AzurePublicCloud", 
    "tenantId": "${var.AZURE_TENANT_ID}",
    "subscriptionId": "${var.AZURE_SUBSCRIPTION_ID}",
    "aadClientId": "${var.AZURE_CLIENT_ID}",
    "aadClientSecret": "${var.AZURE_CLIENT_SECRET}",
    "resourceGroup": "${var.DOCKER_RESOURCE_GROUP}",
    "location": "${var.AZURE_LOCATION}",
    "subnetName": "${var.DOCKER_SUBNET_NAME}",
    "securityGroupName": "${var.DOCKER_NSG_NAME}",
    "vnetName": "${var.DOCKER_VNET_NAME}",
    "cloudProviderBackoff": false,
    "cloudProviderBackoffRetries": 0,
    "cloudProviderBackoffExponent": 0,
    "cloudProviderBackoffDuration": 0,
    "cloudProviderBackoffJitter": 0,
    "cloudProviderRatelimit": false,
    "cloudProviderRateLimitQPS": 0,
    "cloudProviderRateLimitBucket": 0,
    "useManagedIdentityExtension": false,
    "useInstanceMetadata": true
}
EOF1
}

resource "local_file" "azure_ucp_admin_toml" {
    filename = "${path.module}/lin-files/azure_ucp_admin.toml"
    content = <<EOF2
AZURE_SUBSCRIPTION_ID = "${var.AZURE_SUBSCRIPTION_ID}"
AZURE_CLIENT_ID = "${var.AZURE_CLIENT_ID}"
AZURE_CLIENT_SECRET = "${var.AZURE_CLIENT_SECRET}"
AZURE_TENANT_ID = "${var.AZURE_TENANT_ID}"
EOF2

}

