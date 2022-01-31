param namePrefix string

param storageAccountName string

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' existing = {
  name: storageAccountName
}

resource appPlan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: '$namePrefix-app-plan'
  location: resourceGroup().location
  properties: {
    kind: 'App'
    reserved: false
    sku: {
      name: 'F1'
      tier: 'Free'
      size: 'F1'
      family: 'F1'
      capacity: 1
    }
  }
}

resource webApp 'Microsoft.Web/sites@2021-02-01' = {
  name: '$namePrefix-web-app'
  location: resourceGroup().location
  properties: {
    serverFarmId: appPlan.id
  }
}

resource webAppConfig 'Microsoft.Web/sites/config@2021-02-01' = {
  name: 'appsettings'
  parent: webApp
  properties: {
    'StorageConnectionString': 'DefaultEndpointsProtocol=https;AccountName=$storageAccountName;AccountKey=${listKeys(storageAccountName,'2015-05-01-preview').key1}'
  }
}
