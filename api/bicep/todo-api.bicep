resource apim 'Microsoft.ApiManagement/service@2021-08-01' existing = {
  name: 'lunchbytes-apim'
}

resource backend 'Microsoft.ApiManagement/service/backends@2021-08-01' = {
  name: 'todo'
  parent: apim
  properties: {
    description: 'Todo backend'
    protocol: 'http'
    title: 'Todo'
    url: 'https://lunchbytes-web-app.azurewebsites.net/'
  }
}

resource api 'Microsoft.ApiManagement/service/apis@2021-08-01' = {
  name: 'todo'
  parent: apim
  properties: {
    description: 'Todo API'
    displayName: 'Todo API'
    protocols: [
      'https'
    ]
    format: 'swagger-json'
    path: ''
    value: loadTextContent('../swagger.json')
  }
}

resource all_operations_policy 'Microsoft.ApiManagement/service/apis/policies@2021-08-01' = {
  name: 'policy'
  parent: api
  properties: {
    format: 'rawxml'
    value: loadTextContent('policies/all_operations.xml')
  }
}
