var storageAccountName = 'lb${uniqueString(resourceGroup().id)}'


module webapp './modules/webapp.bicep' = {
  name: 'webapp'
  params: {
    namePrefix: 'lunchbytes'
    storageAccountName: storageAccountName
  } 
}

module apim './modules/apim.bicep' = {
  name: 'apim'
  params: {
    namePrefix: 'lunchbytes'
  } 
}
