#!/usr/bin/env bash

# Source Configuration from yaml
source gkubenv/deps/yaml.sh
create_variables gkubenv.yaml

# Styling
bold=$(tput bold)
normal=$(tput sgr0)
red=$(tput setaf 1)

# Prefixes
gcloud_prefix="[gcloud]"
k8s_prefix="[k8s]"

# G Cloud Configuration
if (gcloud config configurations list --format 'value(name)' | grep -q ${project_name}); then
    export CLOUDSDK_ACTIVE_CONFIG_NAME=${project_name}
    echo "${gcloud_prefix} Using existing project configuration: ${bold}${project_name}${normal}"
else
    echo "${gcloud_prefix} Creating new project configuration: ${bold}${project_name}${normal}"
    account=$(gcloud config list account --format "value(core.account)") # using currently selected account
    echo "${gcloud_prefix} Using your currently active account: ${bold}${account}${normal}"
    export CLOUDSDK_ACTIVE_CONFIG_NAME=${project_name}
    gcloud --no-user-output-enabled config configurations create ${project_name}   # Creating new configuration
    gcloud --no-user-output-enabled config configurations activate ${project_name} # Enabling configuration
    gcloud --no-user-output-enabled config set account ${account}                  # Set active account
    gcloud --no-user-output-enabled config set project ${project_name}             # Setting project
    gcloud --no-user-output-enabled config set compute/zone ${default_zone}        # Setting default zone
    gcloud --no-user-output-enabled config set compute/region ${default_region}    # Setting default region
    echo ""
fi

# Kubernetes Configuration
if [ -n "$kubernetes_cluster" ]; then
    export KUBECONFIG=~/.kube/${kubernetes_cluster}.config
    if [ ! -f ~/.kube/${kubernetes_cluster}.config ]; then
        echo "${k8s_prefix} Creating Kubernetes cluster config for ${bold}$kubernetes_cluster${normal}"
        gcloud --no-user-output-enabled beta container clusters get-credentials ${kubernetes_cluster} --region ${default_region} --project ${project_name} # retrieving config from GCP
    else
        echo "${k8s_prefix} Changing active Kubernetes cluster to ${bold}$kubernetes_cluster${normal}"
    fi
fi
