
$Policy_csv = Import-Csv "$PSScriptRoot\RSVPolicyNames.csv"
$output_csv_path ="$PSScriptRoot\PolicyUpdatedCustomerList.csv"

Connect-AzAccount


$header = "rsvName" + "," + "rgName" + "," + "subID" + ","+ "PolicyName" + "," + "vm_name" + "Comments"
$header | Out-File $output_csv_path -Encoding UTF8


$Policy_csv | ForEach-Object{
$PolicyName = $_.PolicyName
$SubID = $_.subID
$rgName = $_.rgName
$rsvName = $_.rsvName
$vmName =$_.vm_name



Select-AzSubscription -SubscriptionId $SubID
$RSVs = Get-AzRecoveryServicesVault 
$vault = Get-AzRecoveryServicesVault -ResourceGroupName $rgName -Name $rsvName

Set-AzRecoveryServicesVaultContext -Vault $vault
##$Container = Get-AzRecoveryServicesBackupContainer -ContainerType "AzureVM" -VaultId $vault.ID -Status Registered 

$RetPol = Get-AzRecoveryServicesBackupRetentionPolicyObject -WorkloadType "AzureVM" 
$SchPol = Get-AzRecoveryServicesBackupSchedulePolicyObject -WorkloadType "AzureVM" 
$Pol= Get-AzRecoveryServicesBackupProtectionPolicy -Name $PolicyName -VaultId $vault.ID
#$Pol.Id.Length
if ($Pol.SchedulePolicy.ScheduleRunFrequency -eq "Weekly"){
        Write-Host ("This is running weekly")

        $SchPol.ScheduleRunFrequency="Daily"
        $RetPol.IsDailyScheduleEnabled=$true
        $RetPol.IsWeeklyScheduleEnabled=$false
        $Pol= Get-AzRecoveryServicesBackupProtectionPolicy -Name $PolicyName -VaultId $vault.ID
        $Pol.SnapshotRetentionInDays=2
        Set-AzRecoveryServicesBackupProtectionPolicy -Policy $Pol -SchedulePolicy $SchPol -RetentionPolicy $RetPol
        $Comments="Updated to run daily"
        $line = $rsvName +','+ $rgName +','+ $SubID+ ',' + $PolicyName +',' +$ContainerName+','+$Comments
        $line | Out-File -Append $output_csv_path -Encoding UTF8



} else{
        $Comments="No Change Needed as this is already running daily"
        $line = $rsvName +','+ $rgName +','+ $SubID+ ',' + $PolicyName +',' +$ContainerName+','+$Comments
        $line | Out-File -Append $output_csv_path -Encoding UTF8

}



}