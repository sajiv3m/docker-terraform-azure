#/bin/bash
# documentation in https://docs.docker.com/docker-for-azure/persistent-data-volumes/

# key parameters

#specific Docker UCP version to install, also the hostname and USER_ID
export DOCKER_STORAGE_ACCOUNT=$1
export DOCKER_STORAGE_ACCOUNT_KEY=$2



# Install Docker Storage plugin - CloudStor

docker plugin install --alias cloudstor:azure \
--grant-all-permissions docker4x/cloudstor:17.06.1-ce-azure1 \
CLOUD_PLATFORM="AZURE" \
AZURE_STORAGE_ACCOUNT_KEY="$DOCKER_STORAGE_ACCOUNT_KEY" \
AZURE_STORAGE_ACCOUNT="$DOCKER_STORAGE_ACCOUNT" \
AZURE_STORAGE_ENDPOINT="core.windows.net" \
DEBUG=1


echo "CloudStor plugin installed..."
