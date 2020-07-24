
Configuration SampleConf
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


[DSCLocalConfigurationManager()]
Configuration LCMConfig
 {
  [CmdletBinding()]
  Param ([string[]]$Node)

  Node $Node
  {
    Settings
        {
        ConfigurationModeFrequencyMins = 21
        ConfigurationMode = "ApplyAndMonitor"
        RefreshMode = "Push"
        RebootNodeIfNeeded = $true
        
        }
  }

}


# Invoke the DSC  Functions and creat the MOF Files

SampleConf -Node "ms1","ms2"

LCMConfig -Node "ms1","ms2"


# Set the Local Config  Manager to use the new MOF for config

Set-DscLocalConfigurationManager -Path .\LCMConfig -Verbose
Get-DscLocalConfigurationManager -CimSession "ms1","ms2"


# Apply the SampleConf config.

Start-DSCConfiguration -Verbose -Wait -Path ".\SampleConf" 


#Test Configuration status

Test-DscConfiguration -CimSession "ms1","ms2"
Test-DscConfiguration -CimSession "ms1","ms2" -Detailed