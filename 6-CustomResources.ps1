#import module xDSCResourceDesigner
Install-Module xDSCResourceDesigner

New-xDscResource -Name MSFT_xADRecycleBin -FriendlyName xADRecycleBin -ModuleName xActiveDirectorytest `
-Path . -Force -Property @(
    New-xDscResourceProperty -Name ForestFQDN                -Type String       -Attribute Key
    New-xDscResourceProperty -Name EnterpriseAdminCredential -Type PSCredential -Attribute Required
    New-xDscResourceProperty -Name RecycleBinEnabled         -Type Boolean      -Attribute Read
    New-xDscResourceProperty -Name ForestMode                -Type String       -Attribute Read
)


#view structure created
tree /F /A

#View MOF with schema
psedit .\xActiveDirectorytest\DSCResources\MSFT_xADRecycleBin\MSFT_xADRecycleBin.schema.mof

#copy items to a modules root
Copy-Item ".\xActiveDirectorytest" "$((($env:PSModulePath) -split ";")[1])\xActiveDirectorytest" -Recurse -Container -Force

#View Resource in module
Get-DscResource -Module xActiveDirectorytest