var storageAccountName = 'lbyte${uniqueString(resourceGroup().id)}'

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
}

// module apim './modules/apim.bicep' = {
//   name: 'apim'
//   params: {
//     namePrefix: 'lunchbytes'
//   } 
// }
