# AzureWebAppforContainers

## Introduction
Azure Container Apps enables you to run microservices and containerized applications on a serverless platform.  For an indepth overview, be sure to check it out at [Azure Container Apps documentation](https://learn.microsoft.com/en-us/azure/container-apps/)

## Build and Deploy Status
[![Build and Deploy Container](https://github.com/RPagels/AzureWebAppforContainers/actions/workflows/Build%20and%20Deploy%20Container.yml/badge.svg)](https://github.com/RPagels/AzureWebAppforContainers/actions/workflows/Build%20and%20Deploy%20Container.yml)

## Detailed Version of Setup
The Detailed Version are step-by-steps for those new to these environments.  The Build & Deployment Pipeline version below below is intended for a quick setup and requires some familiarity with Azure and pipelines, the **EASY BUTTON**.

## Detailed Version of Setup
The Detailed Version are step-by-steps for those new to these environments.  The Build & Deployment Pipeline version below below is intended for a quick setup and requires some familiarity with Azure and pipelines, the **EASY BUTTON**.

## Resource Group

## Define a Service Principal
  - From the Azure Portal home page, search for **Azure Active Directory**.
  - Click **App registrations**.
  - Click **New registration** and give it a name. (i.e. **AzureWebAppForContainers**)
  - Click **Register**
  - Copy the **Client ID** because you will need it in later steps.
  - Copy the **Tenant ID** because you will need it in later steps.



## Generate Deployment Credentials

## Create a GitHub Secret
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
    
> This is a JSON object with the role assignment credentials that provide access to your Azure Resource Group to be used later.

# Build & Deployment Pipeline Setup
- This example uses Biep for Infrastructure as Code to deploy pipeline, Managed Identity is used for Azure Services and will have a unique name based on resource group name.
