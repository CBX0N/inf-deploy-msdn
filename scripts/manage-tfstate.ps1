[CmdletBinding()]
param (
  [Parameter()][string]$tf_rg_name = "rg-tf-cbx-dev-uks-001",
  [Parameter()][string]$tf_sa_name = "satfcbxdevuks001",
  [Parameter()][string]$tf_container_name = "tfstate",
  [Parameter()][string]$location = "uksouth",
  [Parameter()][validateSet("create","destroy",IgnoreCase = $true)]$action = "create"
)

if ("create" -eq $action){
az group create --location $location --resource-group $tf_rg_name 
az storage account create --name $tf_sa_name --resource-group $tf_rg_name --location $location --sku Standard_LRS 
az storage container create --name $tf_container_name --account-name $tf_sa_name 
}

if ("destroy" -eq $action){
az storage container delete --name $tf_container_name --account-name $tf_sa_name 
az storage account delete --name $tf_sa_name --resource-group $tf_rg_name --yes
az group delete --resource-group $tf_rg_name --yes }