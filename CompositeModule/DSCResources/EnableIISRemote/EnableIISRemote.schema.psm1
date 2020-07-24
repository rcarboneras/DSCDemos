Configuration EnableIISRemote {

   Import-DSCResource -ModuleName PSDesiredStateConfiguration
    Registry 'EnableRemoteManagement'
    {
        Key       = 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WebManagement\Server'
        ValueName = 'EnableRemoteManagement'
        Ensure    = 'Present'
        ValueData = 1
        ValueType = 'Dword'
	}

    WindowsFeature 'Web-Mgmt-Service'
    {
        Name   = 'Web-Mgmt-Service'
        Ensure = 'Present' 
    }

    Service 'WMSVC' #Web Management Service
    {
        Name        = 'WMSVC'
        StartupType = 'Automatic'
        State       = 'Running'
        DependsOn   = '[WindowsFeature]Web-Mgmt-Service', '[Registry]EnableRemoteManagement' 
    } 
}#EnableIISRemote 
