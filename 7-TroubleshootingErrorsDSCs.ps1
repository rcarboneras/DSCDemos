#Install module xDSCDiagnostics
Install-Module xDSCDiagnostics -Verbose

#Enable debug and Analytic Logs
#wevtutil.exe set-log 'Microsoft-Windows-Dsc/Analytic' /enabled:true /quiet:false
#wevtutil.exe set-log 'Microsoft-Windows-Dsc/Debug' /enabled:true /quiet:false
Update-xDscEventLogStatus -Status Enabled -Channel Debug -Verbose
Update-xDscEventLogStatus -Status Enabled -Channel Analytic -Verbose

#Check DSConfigurationStatus
Get-DscConfigurationStatus -All -CimSession "ms1","ms2" | Select-Object PsComputername,Status,Startdate,Type,Mode,RebootRequested,NumberOfResources,ResourcesInDesiredState,ResourcesNotInDesiredState | Out-GridView

# Look for Errors
Invoke-Command -ComputerName ms2 -ScriptBlock {Set-Service BITS -StartupType Disabled -Verbose}

configuration TestErrors
{

    node ("ms2")
    {
        Service BITSerror
        {
           Name   = "BITS"
           State = "Running"
        }
        
        file fileerror
        {
        SourcePath = "C:\nopath\nothing.zip"
        DestinationPath = "c:\temp"

        }
    }
}

TestErrors
Start-DscConfiguration -Path .\TestErrors -Wait -Verbose -Force

#trace Operation Job
Get-xDscOperation -ComputerName ms2
Trace-xDscOperation -ComputerName ms2 -JobId "92CD382A-35B4-11E9-80D0-00155DCF711E" | Out-GridView


#Enable Debuging
Enable-DscDebug -CimSession ms2 -BreakAll -Verbose
Disable-DscDebug -CimSession ms2 -Verbose

Start-DscConfiguration -Path .\TestErrors -Wait -Verbose -Force



#Disable Debuging
Disable-DscDebug -CimSession ms2 -Verbose
