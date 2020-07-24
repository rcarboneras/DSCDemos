
Get-DscResource -Name service -Syntax

#Invoke a Resurce
#Set Method
Invoke-DscResource -Name Service -Method Set -Property @{Name = "BITS"; State = "Stopped"} -ModuleName PSDesiredStateConfiguration -Verbose

#Get Method
Invoke-DscResource -Name Service -Method Get -Property @{Name = "BITS"} -Verbose -ModuleName PSDesiredStateConfiguration

#Test Method
Invoke-DscResource -Name Service -Method Test -Property @{Name = "BITS"; State = "Stopped"} -ModuleName PSDesiredStateConfiguration -Verbose
