param namePrefix string



resource apim 'Microsoft.ApiManagement/service@2021-08-01' = {
  name: '${namePrefix}-apim'
  location: resourceGroup().location
  sku: {
    capacity: 1
    name: 'Developer'
  }
  properties: {
    publisherEmail: 'apim@memoryleek.co.uk'
    publisherName: 'Matthew Fortunka'
  }
}

resource apim_target 'Microsoft.ApiManagement/service@2021-08-01' = {
  name: '${namePrefix}-apim-target'
  location: resourceGroup().location
  sku: {
    capacity: 1
    name: 'Developer'
  }
  properties: {
    publisherEmail: 'apim@memoryleek.co.uk'
    publisherName: 'Matthew Fortunka'
  }
}
