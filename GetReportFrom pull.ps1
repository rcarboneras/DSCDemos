function GetReport
{
    param
    (
        [string]$server,
        $serviceURL = "http://PULL.contoso.com:8080/PSDSCPullServer.svc"
    )

    $AgentId = (Get-DscLocalConfigurationManager -CimSession $server).AgentId

    $requestUri = "$serviceURL/Nodes(AgentId='$AgentId')/Reports"
    $request = Invoke-WebRequest -Uri $requestUri  -ContentType "application/json;odata=minimalmetadata;streaming=true;charset=utf-8" `
               -UseBasicParsing -Headers @{Accept = "application/json";ProtocolVersion = "2.0"} `
               -ErrorAction SilentlyContinue -ErrorVariable ev
    $object = ConvertFrom-Json $request.content
    return $object.value
}

GetReport -server ms1