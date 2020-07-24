#https://docs.microsoft.com/en-us/azure/automation/automation-dsc-onboarding
#WMF 5.1
#https://www.microsoft.com/en-us/download/details.aspx?id=54616
#Azure AZ module
#Install-Module Az.Accounts -Verbose
#Install-Module Az.Resources -Verbose
#Install-Module Az.Automation -Verbose
#Prerequisite
#https://support.microsoft.com/en-us/help/4054530/microsoft-net-framework-4-7-2-offline-installer-for-windows


# log in to Azure Resource Manager
Connect-AzAccount #ARM

#Select subcription

Get-AzSubscription
Select-AzSubscription -SubscriptionId "9b262ffa-d4f9-4de0-9eb5-c844a5fead81"
Get-AzContext

# Create ResourceGroup and/or Automation account
$resourcegroupname = "DSCWKS"
$location = "westeurope"

New-AzResourceGroup -Name $resourcegroupname -Location $location -Force

# Get Azure Automation DSC registration info
$aaccount = New-AzAutomationAccount -Name DSCWKS-aa2 -ResourceGroupName $resourcegroupname -Location $location
$RegistrationInfo = $aaccount | Get-AzAutomationRegistrationInfo

#Upload required modules to Azure Automation account using the azure portal or optionally from an URL (storage account)
#Import-AzAutomationModule -Name xPSDesiredStateConfiguration -ResourceGroupName $resourcegroupname -AutomationAccountName $aaccount.AutomationAccountName -ContentLinkUri $URLwiththezipfile



#Upload configurations to Az
#First we change the name of the script (script file has to have the name name that the configuration it contains)
Import-AzAutomationDscConfiguration -SourcePath C:\PShell\DemosRaul\SampleConftoAzure.ps1 -AutomationAccountName $aaccount.AutomationAccountName -ResourceGroupName $resourcegroupname -Verbose -Published
#Compile the configuration (MOF file)
Start-AzAutomationDscCompilationJob -ConfigurationName SampleConftoAzure $aaccount.AutomationAccountName -ResourceGroupName $resourcegroupname -Verbose


# The DSC configuration that will generate metaconfigurations
[DscLocalConfigurationManager()]
Configuration DscMetaConfigs
{
     param
     (
         [Parameter(Mandatory=$True)]
         [String]$RegistrationUrl,

         [Parameter(Mandatory=$True)]
         [String]$RegistrationKey,

         [Parameter(Mandatory=$True)]
         [String[]]$ComputerName,

         [Int]$RefreshFrequencyMins = 30,

         [Int]$ConfigurationModeFrequencyMins = 15,

         [String]$ConfigurationMode = 'ApplyandAutocorrect',

         [String]$NodeConfigurationName,

         [Boolean]$RebootNodeIfNeeded= $False,

         [String]$ActionAfterReboot = 'ContinueConfiguration',

         [Boolean]$AllowModuleOverwrite = $False,

         [Boolean]$ReportOnly
     )

     if(!$NodeConfigurationName -or $NodeConfigurationName -eq '')
     {
         $ConfigurationNames = $null
     }
     else
     {
         $ConfigurationNames = @($NodeConfigurationName)
     }

     if($ReportOnly)
     {
         $RefreshMode = 'PUSH'
     }
     else
     {
         $RefreshMode = 'PULL'
     }

     Node $ComputerName
     {
         Settings
         {
             RefreshFrequencyMins           = $RefreshFrequencyMins
             RefreshMode                    = $RefreshMode
             ConfigurationMode              = $ConfigurationMode
             AllowModuleOverwrite           = $AllowModuleOverwrite
             RebootNodeIfNeeded             = $RebootNodeIfNeeded
             ActionAfterReboot              = $ActionAfterReboot
             ConfigurationModeFrequencyMins = $ConfigurationModeFrequencyMins
         }

         if(!$ReportOnly)
         {
         ConfigurationRepositoryWeb AzureAutomationStateConfiguration
             {
                 ServerUrl          = $RegistrationUrl
                 RegistrationKey    = $RegistrationKey
                 ConfigurationNames = $ConfigurationNames
             }

             ResourceRepositoryWeb AzureAutomationStateConfiguration
             {
             ServerUrl       = $RegistrationUrl
             RegistrationKey = $RegistrationKey
             }
         }

         ReportServerWeb AzureAutomationStateConfiguration
         {
             ServerUrl       = $RegistrationUrl
             RegistrationKey = $RegistrationKey
         }
     }
}

 # Create the metaconfigurations
 # NOTE: DSC Node Configuration names are case sensitive in the portal.
 # TODO: edit the below as needed for your use case
$Params = @{
     RegistrationUrl = $RegistrationInfo.Endpoint;
     RegistrationKey = $RegistrationInfo.PrimaryKey;
     ComputerName = @('pull', 'ms2');
     NodeConfigurationName = 'SampleConftoAzure.localhost';
     RefreshFrequencyMins = 30;
     ConfigurationModeFrequencyMins = 15;
     RebootNodeIfNeeded = $False;
     AllowModuleOverwrite = $False;
     ConfigurationMode = 'ApplyAndMonitor';
     ActionAfterReboot = 'ContinueConfiguration';
     ReportOnly = $false;  # Set to $True to have machines only report to AA DSC but not pull from it
}

# Use PowerShell splatting to pass parameters to the DSC configuration being invoked
# For more info about splatting, run: Get-Help -Name about_Splatting
DscMetaConfigs @Params


#Configure remote LCM

Set-DscLocalConfigurationManager .\DscMetaConfigs -Verbose -Force



