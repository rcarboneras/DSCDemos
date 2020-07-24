
#View Configuration Status detail
Get-DscConfigurationStatus
(Get-xDscConfigurationDetail) | Select-Object ResourcesInDesiredState,ResourcesNotInDesiredState
Get-xDscConfigurationDetail (Get-DscConfigurationStatus)


#View Current configuration
Unprotect-xDscConfiguration -Stage Current