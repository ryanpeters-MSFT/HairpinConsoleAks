$group = "rg-aks-hairpin"
$cluster = "hairpincluster"

# create the group
az group create -n $group -l eastus2

# create the cluster
az aks create -n $cluster -c 1 -g $group --network-plugin azure

# get credentials
az aks get-credentials -n $cluster -g $group --overwrite-existing