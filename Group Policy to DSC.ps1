#RCM

#This script generates a DSC configuration from domain GPO
Install-Module DSCEA -verbose
Install-Module AuditPolicyDsc -verbose
Install-Module BaselineManagement -verbose
Install-Module SecurityPolicyDSC -verbose

#PowerShellAccessControl module
#https://gallery.technet.microsoft.com/scriptcenter/PowerShellAccessControl-d3be7b83

#region Security Baseline
#Download the security baseline from your O.S. from this link:
#https://www.microsoft.com/en-us/download/details.aspx?id=55319

#endregion

#Get current GPOs
$GPONames = "DSCPolicyDonotDisplayServerManager"
New-Item -ItemType Directory -Name GPOBackups
foreach ($GPOName in $GPONAmes)
{
Get-GPO -Name $GPOName | Backup-GPO -Path "$((Get-Location).Path)\GPOBackups"
}

$BackupGPOs = Get-ChildItem -Path "$((Get-Location).Path)\GPOBackups"

#Restore all GPO from backup Folder
#$ids = (Get-ChildItem -Path "$((Get-Location).Path)\GPOBackups").Name -replace "[{,}]"
#foreach ($id in $ids)
#{
#Restore-GPO -Path "$((Get-Location).Path)\GPOBackups" -BackupId $id -Verbose -Domain "contoso.com"
#}


#Generate DSC configuration ps1 file and MOF file

New-Item -ItemType Directory -Name DSCFromGPO
($BackupGPOs).Fullname | ConvertFrom-GPO -ComputerName server -OutputConfigurationScript -OutputPath .\DSCFromGPO


# Generates a DSCEA report
New-Item -ItemType Directory -Name Output
Start-DSCEAscan -ComputerName server -MofFile .\Output\server.mof -OutputPath .\Output
Set-Location .\output
Get-DSCEAreport -Overall

#Check MOF againts a server or several:
$results = Test-DscConfiguration -ReferenceConfiguration .\DSCFromGPO\server.mof -CimSession ms1
$results | Select-Object -Property pscomputername,@{N = "ResourcesNotInDesiredState"; E = {($_.ResourcesNotInDesiredState).InstanceName}}
$results[1].ResourcesNotInDesiredState.Instancename


