#region Building the pull server
Configuration Sample_xDscWebServiceRegistration
{
    param
    (
        [Parameter()]
        [System.String[]]
        $NodeName = 'localhost',

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $CertificateThumbPrint,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $RegistrationKey
    )

    Import-DSCResource -ModuleName xPSDesiredStateConfiguration

    Node $NodeName
    {
        WindowsFeature DSCServiceFeature
        {
            Ensure = 'Present'
            Name   = 'DSC-Service'
        }

        xDscWebService PSDSCPullServer
        {
            Ensure                       = 'Present'
            EndpointName                 = 'PSDSCPullServer'
            Port                         = 8080
            PhysicalPath                 = "$env:SystemDrive\inetpub\PSDSCPullServer"
            CertificateThumbPrint        = $CertificateThumbPrint
            ModulePath                   = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Modules"
            ConfigurationPath            = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Configuration"
            State                        = 'Started'
            DependsOn                    = '[WindowsFeature]DSCServiceFeature'
            RegistrationKeyPath          = "$env:PROGRAMFILES\WindowsPowerShell\DscService"
            AcceptSelfSignedCertificates = $true
            Enable32BitAppOnWin64        = $false
            UseSecurityBestPractices     = $true
        }

        File RegistrationKeyFile
        {
            Ensure          = 'Present'
            Type            = 'File'
            DestinationPath = "$env:ProgramFiles\WindowsPowerShell\DscService\RegistrationKeys.txt"
            Contents        = $RegistrationKey
        }
    }
}


#Get web server certificate

$newcert = Get-Certificate `
-Template WebServer `
-DnsName "pull.contoso.com" `-CertStoreLocation "Cert:\LocalMachine\My" `
-Verbose
$newcert.Certificate.FriendlyName = "Pull Web Certificate"

Get-ChildItem -Path Cert:\LocalMachine\My
$CertificateThumbPrint = $newcert.Certificate.Thumbprint

#Generate a Registration key
$RegistrationKey = (New-Guid).Guid

Sample_xDscWebServiceRegistration -NodeName "pull" -RegistrationKey $RegistrationKey -CertificateThumbPrint $CertificateThumbPrint

Start-DscConfiguration -Path .\Sample_xDscWebServiceRegistration -Wait -Verbose -Force
#endregion

#region Creating and uploading MOF Files

Configuration ClientConfig
 {
  [CmdletBinding()]
  Param ([string[]]$Node)

  Import-DscResource -Name WindowsFeature -ModuleName PSDesiredStateConfiguration
  Node $node

  {
    File Testfile
       {
       Type = 'File'
       DestinationPath = 'c:\testFile.txt'
       Ensure = 'Present'
       Contents = 'Configuration present'
       }

    WindowsFeature ActiveDirectoryConsole
      {
       Ensure = "Present" 
       Name = "RSAT-AD-Tools"

      }

    WindowsFeature DNSConsole
      {
       Ensure = "Absent" 
       Name = "RSAT-DNS-Server"
      }

  }

  }


Configuration SecureServer
{
  [CmdletBinding()]
  Param ([string[]]$Node)

Import-DscResource -ModuleName xPowerShellExecutionPolicy
    Node $node
    {
      xPowerShellExecutionPolicy SecurePolicy
      {
            ExecutionPolicy = "RemoteSigned"
            ExecutionPolicyScope = "LocalMachine"
      }

}
}


ClientConfig -Node localhost -Verbose
SecureServer -Node localhost -Verbose

#Publish MOF2 to the pull server
$source = ".\ClientConfig\localhost.mof"
$destination = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Configuration\ClientConfig.mof"
Copy-Item -Path $source -Destination $destination -PassThru
New-DscChecksum -Path $destination -Verbose -Force

$source = ".\SecureServer\localhost.mof"
$destination = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Configuration\SecureServer.mof"
Copy-Item -Path $source -Destination $destination -PassThru
New-DscChecksum -Path $destination -Verbose -Force



#endregion

#region Configuring target servers
[DSCLocalConfigurationManager()]
Configuration Sample_MetaConfigurationToRegisterWithSecurePullServer
{
    param
    (
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $NodeName = 'localhost',

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $RegistrationKey,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $ServerName = 'localhost'
    )

    Node $NodeName
    {
        Settings
        {
            RefreshMode = 'Pull'
        }

        ConfigurationRepositoryWeb CONTOSO-PullSrv
        {
            ServerURL          = "https://$ServerName`:8080/PSDSCPullServer.svc"
            RegistrationKey    = $RegistrationKey
            ConfigurationNames = @('ClientConfig','SecureServer')
        }

        PartialConfiguration ClientConfig
        {
            Description = 'Client Configuration.'
            ConfigurationSource = @("[ConfigurationRepositoryWeb]CONTOSO-PullSrv")
            RefreshMode = 'Pull'
        }

        PartialConfiguration SecureServer
        {
            Description = 'Set PowerShell execution policy'
            ConfigurationSource = @("[ConfigurationRepositoryWeb]CONTOSO-PullSrv")
            RefreshMode = 'Pull'
        }

        ReportServerWeb CONTOSO-PullSrv
        {
            ServerURL       = "https://$ServerName`:8080/PSDSCPullServer.svc"
            RegistrationKey = $RegistrationKey
        }
#        ReportServerWeb AzureAutomationStateConfiguration
#         {
#             ServerUrl       = $RegistrationUrl #AutomationAccount URL
#             RegistrationKey = $RegistrationKey #Primary Access Key
#         }
    }
}


#Generating meta mof file
Sample_MetaConfigurationToRegisterWithSecurePullServer `
-NodeName "ms2" `
-ServerName "pull.contoso.com" `
-RegistrationKey $RegistrationKey


Set-DscLocalConfigurationManager -Path .\Sample_MetaConfigurationToRegisterWithSecurePullServer -Verbose -Force
#endregion
