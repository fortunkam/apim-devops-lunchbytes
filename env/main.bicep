var storageAccountName = 'lb${uniqueString(resourceGroup().id)}'

module storage './modules/storage.bicep' = {
  name: 'storage'
  params: {
    name: storageAccountName
  } 
}

module webapp './modules/webapp.bicep' = {
  name: 'webapp'
  params: {
    namePrefix: 'lunchbytes'
    storageAccountName: storageAccountName
  } 
  dependsOn: [
    storage
  ]
}

// module apim './modules/apim.bicep' = {
//   name: 'apim'
//   params: {
//     namePrefix: 'lunchbytes'
//   } 
// }
