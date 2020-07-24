#https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/protect-cmsmessage?view=powershell-5.1


#Look for certificates with document encryption enhanced key usage
Get-ChildItem -Path Cert:\LocalMachine\My -DocumentEncryptionCert


#Encrypt message
$Protected = "Hello World" | Protect-CmsMessage -To "83D66B88843288B720E37B29A1605A22072801BE" #Thumbnail of the certificate.
$Protected | Unprotect-CmsMessage # Only in the server that has the certificate
Get-CmsMessage -Content $Protected

#Encrypt entire MOF
$protectedmof = Get-Content .\sample.mof | Protect-CmsMessage -To "83D66B88843288B720E37B29A1605A22072801BE" #Thumbnail of the certificate.
$protectedmof | Out-File .\sampleencrypted.mof

Get-Content .\sampleencrypted.mof | Unprotect-CmsMessage | Out-File sampledecrypted.mof






