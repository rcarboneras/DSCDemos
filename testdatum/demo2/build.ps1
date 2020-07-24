$SRV01 = @{
    Nodename = 'SRV01'
    Location = 'London'
    Role     = 'SomeRole'
}
$SRV02 = @{
    Nodename = 'SRV02'
    Location = 'Paris'
    Role     = 'webserver'
}

Import-Module Datum
$Datum = New-DatumStructure -DefinitionFile .\Datum.yml

lookup 'Network' -Node $SRV01 -DatumTree $Datum
lookup 'Firewall' -Node $SRV02 -DatumTree $Datum

$red = lookup 'Network' -Node $SRV02 -DatumTree $Datum
$red.Gateway
$firewall = lookup 'Firewall' -Node $SRV02 -DatumTree $Datum
$firewall.Rules
$firewall.Rules.secure
