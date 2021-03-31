$RSV_csv = Import-Csv "$PSScriptRoot\Azurevaults_rsv.csv"

Connect-AzAccount
$output_csv_path = "$PSScriptRoot\RSVPolicyNames.csv"


$PolicyCSV = [PSCustomObject]@{
    SubID     = 'SubID'
    rgName = 'rgName'
    rsvName    = 'rsvName'
    PolicyName ='PolicyName'
}


$header = "rsvName" + "," + "rgName" + "," + "subID" + ","+ "PolicyName" + "," + "vm_name"
$header | Out-File $output_csv_path -Encoding UTF8

$RSV_csv | ForEach-Object{
$Name = $_.Name
$SubID = $_.SUBSCRIPTION_ID
$rgName = $_.RESOURCE_GROUP
$rsvName = $_.NAME

write-host "Name is $Name and subscription $SubID $rgName"

Select-AzSubscription -SubscriptionId $SubID
$vault = Get-AzRecoveryServicesVault -ResourceGroupName $rgName -Name $rsvName

$Container = Get-AzRecoveryServicesBackupContainer -ContainerType "AzureVM" -VaultId $vault.ID -Status Registered 

for ($i = 0; $i -lt ($Container.FriendlyName.Length  ); $i +=1  ){

$ContainerName = $Container.FriendlyName[$i]
$ContainerItem = Get-AzRecoveryServicesBackupContainer -ContainerType AzureVM -Status Registered -FriendlyName $ContainerName -VaultId $vault.ID
write-host "Current Container Name is $ContainerName "
#$namedContainer=Get-AzRecoveryServicesBackupContainer -ContainerType "AzureVM" -Status "Registered" -FriendlyName $ContainerName -VaultId $vault.ID
#$item = Get-AzRecoveryServicesBackupItem -Container  $namedContainer -WorkloadType "AzureVM"
$item = Get-AzRecoveryServicesBackupItem  -WorkloadType "AzureVM"  -VaultId $vault.ID  -Container $ContainerItem
$PolicyName= $item.ProtectionPolicyName
write-host "POLICy Name iS $PolicyName"

$item = Get-AzRecoveryServicesBackupItem  -WorkloadType "AzureVM"  -VaultId $vault.ID  -Container $ContainerItem

$line = $rsvName +','+ $rgName +','+ $SubID+ ',' + $PolicyName +',' +$ContainerName
$line | Out-File -Append $output_csv_path -Encoding UTF8


}






}