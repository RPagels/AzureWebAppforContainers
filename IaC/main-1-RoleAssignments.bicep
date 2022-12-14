param containerAppName string
param principalId string

//ACRPull Role Assignment
param roleDefinitionId string = '7f951dda-4ed3-4680-a7ca-43fe172d538d'
var secretUserRole = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionId)

// Add role assigment for Service Identity
// Azure built-in roles - https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles
//var ACRPull_roleAssignmentRoleDefinitionId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d')

resource existing_ContainerApp 'Microsoft.App/containerApps@2022-06-01-preview' existing = {
  name: containerAppName
}

// Add role assignment to Container App
resource roleAssignmentForContainerApp 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(existing_ContainerApp.id, secretUserRole)
  scope: existing_ContainerApp
  properties: {
    //principalType: 'ServicePrincipal'
    principalId: principalId
    //principalId: reference(existing_ContainerApp.id, existing_ContainerApp.apiVersion, 'Full').identity.principalId
    //principalId: reference(containerApp.id, '2022-06-01-preview', 'Full').identity.principalId
    roleDefinitionId: secretUserRole
  }
}
