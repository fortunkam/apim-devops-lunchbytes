param namePrefix string

param storageAccountName string


@allowed([
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GRS'
  'Standard_GZRS'
  'Standard_LRS'
  'Standard_RAGRS'
  'Standard_RAGZRS'
  'Standard_ZRS'
])
param storageAccountType string = 'Standard_LRS'

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: storageAccountName
  location: resourceGroup().location
  sku: {
    name: storageAccountType
  }
  kind: 'StorageV2'
  properties: {}
}

resource appPlan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: '${namePrefix}-app-plan'
  location: resourceGroup().location
  sku: {
    name: 'F1'
    capacity: 1
  }
}

resource webApp 'Microsoft.Web/sites@2021-02-01' = {
  name: '${namePrefix}-web-app'
  location: resourceGroup().location
  properties: {
    serverFarmId: appPlan.id
  }
}

resource webAppConfig 'Microsoft.Web/sites/config@2021-02-01' = {
  name: 'appsettings'
  parent: webApp
  properties: {
    'StorageConnectionString': 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};AccountKey=${listKeys(storageAccount.id,storageAccount.apiVersion).keys[0].value}'
  }
}
