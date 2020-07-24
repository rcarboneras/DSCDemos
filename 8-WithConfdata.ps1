configuration Name
{

Import-DscResource -ModuleName PSdesiredstateconfiguration


	Node $AllNodes.Where{$_.Role -eq "WebServer"}.NodeName
    {
		WindowsFeature IISInstall
         {
			Ensure = 'Present'
			Name   = 'Web-Server'
	     }
	}

    Node $AllNodes.Where{$_.Role -eq "Hyper-v"}.NodeName
       {
    	WindowsFeature HypervInstall
            {
    		Ensure = 'Present'
    		Name   = 'Hyper-V'
         }
    }

}



$confdata=@{
    AllNodes = @(
        @{
            NodeName = "Node1"
            Role = "WebServer"
            },
        @{
            NodeName = "Node2"
            Role = "Hyper-V"
            },
        @{
            NodeName = "Node3"
            Role = "WebServer"
            }
    )
}

$confdata = Import-LocalizedData -FileName temp.psd1

name -ConfigurationData $confdata
# Save ConfigurationData in a file with .psd1 file extension

