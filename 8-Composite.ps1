Configuration IISRemote {
	param (
    [parameter(mandatory)]
    [String[]]$ComputerName
    )
   Import-DSCResource -Name EnableIISRemote -ModuleName CompositeModule

	Node $ComputerName 
   {
       EnableIISRemote IISGUI 
		{
			
		}      
   }

}#IISRemote

IISRemote -ComputerName Web-VM-01.contoso.com
Start-DscConfiguration -Path .\IISRemote -Wait -Verbose -Force 

