output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "key_vault_name" {
  value = azurerm_key_vault.kv.name
}

output "appinsights_instrumentation_key" {
  value     = azurerm_application_insights.appinsights.instrumentation_key
  sensitive = true
}

output "get_credentials_command" {
  value = "az aks get-credentials --resource-group ${azurerm_resource_group.rg.name} --name ${azurerm_kubernetes_cluster.aks.name}"
}