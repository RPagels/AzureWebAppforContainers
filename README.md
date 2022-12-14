# AzureWebAppforContainers

## Introduction
Azure Container Apps enables you to run microservices and containerized applications on a serverless platform.  For an indepth overview, be sure to check it out at [Azure Container Apps documentation](https://learn.microsoft.com/en-us/azure/container-apps/)

## Build and Deploy Status
[![Build and Deploy Container](https://github.com/RPagels/AzureWebAppforContainers/actions/workflows/Build%20and%20Deploy%20Container.yml/badge.svg)](https://github.com/RPagels/AzureWebAppforContainers/actions/workflows/Build%20and%20Deploy%20Container.yml)

## Setup Steps
Follow the steps below for detailed instructions on how to run this in your environment.  The Build & Deployment Pipeline version below below is intended for a quick setup and requires some familiarity with Azure and pipelines, the **EASY BUTTON**.

## Step 1 - Resource Group
  - Create a resource group (pick a region which allows Containers - at the time of this edit the allowed regions were: (northcentralusstage,eastus,eastus2,northeurope,canadacentral) (To do - insert a PS command or web url to display the regions in real-time)

## Step 2 - Create a Service Principal
  ## Option A
  - Open the Cloud Shell and run this PowerShell command:
  - az ad sp create-for-rbac --name "{REPLACE WITH RG NAME}_SP_FullAccess" --role owner --scopes /subscriptions/{REPLACE WITH SUBSRIPTION ID}/resourceGroups/{REPLACE WITH RG NAME} (To do- create one PS command to do step 1 and step 2)
  - Copy the JSON output to notepad for use later

  ## Option B
  - From the Azure Portal home page, search for **Azure Active Directory**.
  - Click **App registrations**.
  - Click **New registration** and give it a name. (i.e. **AzureWebAppForContainers**)
  - Click **Register**
  - Copy the **Client ID** because you will need it in later steps.
  - Copy the **Tenant ID** because you will need it in later steps.
  - Copy the **Object ID** because you will need it in later steps.


  ## Step 3 - Edit bicep file
  - open /IaC/main-1.bicep
  - Edit these two lines with the object id and application id
   // Object Id of Service Principal "AzureWebAppforContainerApps_FullAccess"
   param ADOServiceprincipalObjectId string = '{Object ID}'
   // Application Id of Service Principal "RPagels" Alias.
   param AzObjectIdPagels string = '{Application ID}'

To Do - remove RPagels from comments
To Do - change the variable name from AzObjectIdPagels to AzServicePrincipalApplicationID
To Do - change the variable name from ADOServiceprincipalObjectID to AzServicePrincipalObjectID
To Do - generate these two lines in the PS

## Step 4 - Set Deployment Credentials - Create a GitHub Secret

  - Copy the following to notepad.
> {
>    "clientId": "<GUID>",
>    "clientSecret": "<GUID>",
>    "subscriptionId": "<GUID>",
>    "tenantId": "<GUID>"
>  }

  - Replace the placeholders with your information from above steps **Generate Deployment Credentials**:
    - Subscription ID
    - Resource Group name
    - App Mame. The output is 
  - Create the secret
    - use the name AZURE_CREDENTIALS


  To Do - generate the GitHub JSON
  
> This is a JSON object with the role assignment credentials that provide access to your Azure Resource Group to be used later.

# Build & Deployment Pipeline Setup
- This example uses Biep for Infrastructure as Code to deploy pipeline, Managed Identity is used for Azure Services and will have a unique name based on resource group name.
