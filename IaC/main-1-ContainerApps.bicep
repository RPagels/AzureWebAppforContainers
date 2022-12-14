param containerAppName string
param containerAppEnvName string
param containerAppLogAnalyticsName string
param containerregistryName string
param containerregistryNameLoginServer string

@secure()
param containerregistryNameCredentials string

param defaultTags object

// Specifies the docker container image to deploy.')
param containerImage string

@description('Specifies the location for all resources.')
@allowed([
  'northcentralusstage'
  'eastus'
  'eastus2'
  'northeurope'
  'canadacentral'
])
param location string //cannot use resourceGroup().location since it's not available in most of regions

@description('Specifies the container port.')
param targetPort int = 80

@description('Number of CPU cores the container can use. Can be with a maximum of two decimals.')
param cpuCore string = '0.5'

@description('Amount of memory (in gibibytes, GiB) allocated to the container up to 4GiB. Can be with a maximum of two decimals. Ratio with CPU cores must be equal to 2.')
param memorySize string = '1'

@description('Minimum number of replicas that will be deployed')
@minValue(0)
@maxValue(25)
param minReplicas int = 1

@description('Maximum number of replicas that will be deployed')
@minValue(0)
@maxValue(25)
param maxReplicas int = 3

// resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
//   name: containerAppLogAnalyticsName
//   location: location
//   properties: {
//     sku: {
//       name: 'PerGB2018'
//     }
//   }
// }

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: containerAppLogAnalyticsName
  location: location
  properties: any({
    retentionInDays: 30
    features: {
      searchVersion: 1
    }
    sku: {
      name: 'PerGB2018'
    }
  })
}

//resource containerAppEnv 'Microsoft.Web/kubeEnvironments@2022-03-01' = { 
  resource containerAppEnv 'Microsoft.App/managedEnvironments@2022-06-01-preview' = {
  name: containerAppEnvName
  location: location
  tags: defaultTags
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: logAnalytics.properties.customerId
        sharedKey: logAnalytics.listKeys().primarySharedKey
      }
    }
  }
}

// Reference Existing resource
// resource existing_containerregistry 'Microsoft.ContainerRegistry/registries@2022-02-01-preview' existing = {
//   name: containerregistryName
// }

// Create Container App
// Note: revisionSuffix MUST BE unique per deployment.
resource containerApp 'Microsoft.App/containerApps@2022-06-01-preview' = {
  name: containerAppName
  location: location
  tags: defaultTags
  // identity: {
  //   type: 'SystemAssigned'
  // }
  properties: {
    managedEnvironmentId: containerAppEnv.id
    configuration: {
       ingress: {
         external: true
         targetPort: targetPort
         allowInsecure: false
         traffic: [
           {
             latestRevision: true
             weight: 100
           }
         ]
       }
      registries: [
        {
          server: containerregistryNameLoginServer //existing_containerregistry.properties.loginServer
          username: containerregistryName
          passwordSecretRef: containerregistryName //existing_containerregistry.name
        }
      ]
      secrets: [
        {
          name: containerregistryName //existing_containerregistry.name
          value: containerregistryNameCredentials //existing_containerregistry.listCredentials().passwords[0].value
        }
      ]
   }
    template: {
      containers: [
        {
          name: containerAppName
          image: containerImage
          resources: {
            cpu: json(cpuCore)
            memory: '${memorySize}Gi'
          }
          probes: [
            {
              type: 'liveness'
              httpGet: {
              path: '/health'
              port: 8080
              }
            initialDelaySeconds: 7
            periodSeconds: 3
            }
            {
              type: 'readiness'
              httpGet: {
              port: 8081
              }
            initialDelaySeconds: 10
            periodSeconds: 3
            }
            {
              type: 'startup'
              httpGet: {
              path: '/startup'
              port: 8080
              }
            initialDelaySeconds: 3
            periodSeconds: 3
            }
          ]
        }
      ]
      scale: {
        minReplicas: minReplicas
        maxReplicas: maxReplicas
      }
    }
  }
}

// Add role assigment for Service Identity
// Azure built-in roles - https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles
var ACRPull_roleAssignmentRoleDefinitionId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d')

// Add role assignment to Container App
resource roleAssignmentForContainerApp 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(containerApp.id, ACRPull_roleAssignmentRoleDefinitionId)
  scope: containerApp
  properties: {
    principalType: 'ServicePrincipal'
    principalId: reference(containerApp.id, containerApp.apiVersion, 'Full').identity.principalId
    //principalId: reference(containerApp.id, '2022-06-01-preview', 'Full').identity.principalId
    roleDefinitionId: ACRPull_roleAssignmentRoleDefinitionId
  }
}

output containerAppFQDN string = containerApp.properties.configuration.ingress.fqdn
