#requires -Version 4

configuration MSFT_xWebsite_Present_Started
{
    param(
        
        [Parameter(Mandatory = $true)]
        [String] $CertificateThumbprint
    
    )

    Import-DscResource -ModuleName xWebAdministration

    Node $AllNodes.NodeName
    {  
        xWebsite Website
        {
            Name = $Node.Website
            Ensure = 'Present'
            ApplicationType = $Node.ApplicationType
            ApplicationPool = $Node.ApplicationPool
            AuthenticationInfo = `
                MSFT_xWebAuthenticationInformation
                {
                    Anonymous = $Node.AuthenticationInfoAnonymous
                    Basic     = $Node.AuthenticationInfoBasic
                    Digest    = $Node.AuthenticationInfoDigest
                    Windows   = $Node.AuthenticationInfoWindows
                }
                BindingInfo = @(MSFT_xWebBindingInformation
                {
                    Protocol              = $Node.HTTPProtocol
                    Port                  = $Node.HTTPPort
                    IPAddress             = '*'
                    Hostname              = $Node.HTTP1Hostname
                }
                MSFT_xWebBindingInformation
                {
                    Protocol              = $Node.HTTPProtocol
                    Port                  = $Node.HTTPPort
                    IPAddress             = '*'
                    Hostname              = $Node.HTTP2Hostname
                }
                MSFT_xWebBindingInformation
                {
                    Protocol              = $Node.HTTPSProtocol
                    Port                  = $Node.HTTPSPort
                    IPAddress             = '*'
                    Hostname              = $Node.HTTPSHostname
                    CertificateThumbprint = $CertificateThumbprint
                    CertificateStoreName  = $Node.CertificateStoreName
                    SslFlags              = $Node.SslFlags
                }
                MSFT_xWebBindingInformation
                {
                    Protocol              = $Node.HTTPSProtocol
                    Port                  = $Node.HTTPSPort2
                    IPAddress             = '*'
                    Hostname              = $Node.HTTPSHostname
                    CertificateSubject    = $Node.HTTPSHostname
                    CertificateStoreName  = $Node.CertificateStoreName
                    SslFlags              = $Node.SslFlags
                })
                DefaultPage = $Node.DefaultPage
                EnabledProtocols = $Node.EnabledProtocols
                PhysicalPath = $Node.PhysicalPath
                PreloadEnabled = $Node.PreloadEnabled
                ServiceAutoStartEnabled = $Node.ServiceAutoStartEnabled
                ServiceAutoStartProvider = $Node.ServiceAutoStartProvider
                State = 'Started'
                LogCustomFields    = @(
                    MSFT_xLogCustomFieldInformation
                    {
                        LogFieldName = $Node.LogFieldName1
                        SourceName   = $Node.SourceName1
                        SourceType   = $Node.SourceType1
                    }
                    MSFT_xLogCustomFieldInformation
                    {
                        LogFieldName = $Node.LogFieldName2
                        SourceName   = $Node.SourceName2
                        SourceType   = $Node.SourceType2
                    }
                )
        }
    }
}

configuration MSFT_xWebsite_Present_Stopped
{
    param(
        
        [Parameter(Mandatory = $true)]
        [String]$CertificateThumbprint
    
    )

    Import-DscResource -ModuleName xWebAdministration

    Node $AllNodes.NodeName 
    {  
        xWebsite Website
        {
            Name = $Node.Website
            Ensure = 'Present'
            ApplicationType = $Node.ApplicationType
            ApplicationPool = $Node.ApplicationPool
            AuthenticationInfo = `
                MSFT_xWebAuthenticationInformation
                {
                    Anonymous = $Node.AuthenticationInfoAnonymous
                    Basic     = $Node.AuthenticationInfoBasic
                    Digest    = $Node.AuthenticationInfoDigest
                    Windows   = $Node.AuthenticationInfoWindows
                }
            BindingInfo = @(
                MSFT_xWebBindingInformation
                {
                    Protocol              = $Node.HTTPProtocol
                    Port                  = $Node.HTTPPort
                    IPAddress             = '*'
                    Hostname              = $Node.HTTP1Hostname
                }
                MSFT_xWebBindingInformation
                {
                    Protocol              = $Node.HTTPProtocol
                    Port                  = $Node.HTTPPort
                    IPAddress             = '*'
                    Hostname              = $Node.HTTP2Hostname
                }
                MSFT_xWebBindingInformation
                {
                    Protocol              = $Node.HTTPSProtocol
                    Port                  = $Node.HTTPSPort
                    IPAddress             = '*'
                    Hostname              = $Node.HTTPSHostname
                    CertificateThumbprint = $CertificateThumbprint
                    CertificateStoreName  = $Node.CertificateStoreName
                    SslFlags              = $Node.SslFlags
                }
                MSFT_xWebBindingInformation
                    {
                    Protocol              = $Node.HTTPSProtocol
                    Port                  = $Node.HTTPSPort2
                    IPAddress             = '*'
                    Hostname              = $Node.HTTPSHostname
                    CertificateSubject    = $Node.HTTPSHostname
                    CertificateStoreName  = $Node.CertificateStoreName
                    SslFlags              = $Node.SslFlags
                })
            DefaultPage = $Node.DefaultPage
            EnabledProtocols = $Node.EnabledProtocols
            PhysicalPath = $Node.PhysicalPath
            PreloadEnabled = $Node.PreloadEnabled
            ServiceAutoStartEnabled = $Node.ServiceAutoStartEnabled
            ServiceAutoStartProvider = $Node.ServiceAutoStartProvider
            State = 'Stopped'
            LogCustomFields    = @(
                MSFT_xLogCustomFieldInformation
                {
                    LogFieldName = $Node.LogFieldName1
                    SourceName   = $Node.SourceName1
                    SourceType   = $Node.SourceType1
                }
                MSFT_xLogCustomFieldInformation
                {
                    LogFieldName = $Node.LogFieldName2
                    SourceName   = $Node.SourceName2
                    SourceType   = $Node.SourceType2
                }
            )
        }
    }
}

configuration MSFT_xWebsite_Absent
{
    Import-DscResource -ModuleName xWebAdministration

    Node $AllNodes.NodeName 
    {  
        xWebsite Website
        {
            Name = $Node.Website
            Ensure = 'Absent'
        }
    }
}
