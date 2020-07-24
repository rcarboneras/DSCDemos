#Download las version of xPSDesiredStateConfiguration module (contains the Publish-ModuleToPullServer function)
Install-Module xPSDesiredStateConfiguration

#Download module to publish from Powershell Gallery
Install-Module xactivedirectory

#Publish module to PullServer
Publish-ModuleToPullServer -Name "xActiveDirectory" -ModuleBase "C:\Program Files\WindowsPowerShell\Modules\xActiveDirectory" -Version "2.23.0.0" -Verbose

#Publish module and MOF files
$ModuleList = $moduleList = @('xWebAdministration', 'xActiveDirectory')
Publish-DSCModuleAndMof -Source "C:\PShell\DemosRaul\Modules" -ModuleNameList $ModuleList

#MOF configuration

configuration TestADmoduledownload
{
 Import-DscResource -ModuleName xActiveDirectory
    Node ("localhost")
    {
             xADReplicationSite CentralSite #ResourceName
            {
                Name = "CentralSite"
                RenameDefaultFirstSiteName = $true
            }
    }
}

#Generate MOF
TestADmoduledownload

#copy MOF to pull server
$guid = New-Guid
$source = ".\TestADmoduledownload\localhost.mof"
$destination = "C:\Program Files\WindowsPowerShell\DscService\Configuration\$($guid).mof"
Copy-Item $source $destination

#Generate checksum
New-DscChecksum "C:\Program Files\WindowsPowerShell\DscService\Configuration\$($guid).mof"

#check remote modules folder
start "\\dc\c$\Program Files\WindowsPowerShell\Modules"

#Configure target LCM
[DscLocalConfigurationManager()]
Configuration LCMPullv5DC
{
Param (
    $ComputerName,
    $GUID
)
    Node $ComputerName
    {
        Settings
        {
            ActionAfterReboot              = 'ContinueConfiguration'
            AllowModuleOverWrite           = $True
            ConfigurationID                = $GUID
            ConfigurationMode              = 'ApplyAndAutocorrect'
            ConfigurationModeFrequencyMins = 15
            RefreshFrequencyMins           = 30
            StatusRetentionTimeInDays      = 7
            RebootNodeIfNeeded             = $True
            RefreshMode                    = 'Pull'

        }
        ConfigurationRepositoryWeb PullServer
        {
            ServerURL                = "http://pull.contoso.com:8080/PSDSCPullServer.svc"
            AllowUnsecureConnection  = $true
        }
    }
}

LCMPullv5DC -ComputerName dc -GUID $guid -Verbose

Set-DscLocalConfigurationManager .\LCMPullv5DC -CimSession dc -Verbose

#check remote modules folder
start "\\dc\c$\Program Files\WindowsPowerShell\Modules"


