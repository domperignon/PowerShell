#
# Script.ps1
#
# Add-AzureAccount


#Get-AzureStorageAccount



function MyFunc {
param ($command, $vars ,$timeout)

$timeout = $timeout + 3

$SomeJob = Start-Job -ScriptBlock $command -ArgumentList $vars
$SomeJob | Wait-Job -Timeout $timeout | Out-Null

if ( $JobObj.State -ne 'Completed' ) {
Write-Output 'Job Sucked'
#$job | Stop-Job
}
else {
Write-Output 'Job OK'
}
$JobObj | Receive-Job


$SomeJob | Receive-Job

}

$JobBlobCommand = {
    param ($storacc, $key, $contnr)
    $ctx = New-AzureStorageContext -StorageAccountName $storacc -StorageAccountKey $key
    Get-AzureStorageBlob -Container $contnr -Context $ctx
}

MyFunc -command $JobBlobCommand -vars ($storacc,$key,$contnr_item.name) -timeout 10


New-AzureStorageContainer -Name 'testcont' -Context $ctx
Get-Azure


$storacc = 'eastus2storacc1'
$key = (Get-AzureStorageKey -StorageAccountName $storacc).Primary
$ctx = New-AzureStorageContext -StorageAccountName $storacc -StorageAccountKey $key
$cont = Get-AzureStorageContainer -Context $ctx


powershell -command {

		param ($key,$storacc)
		$key = (Get-AzureStorageKey -StorageAccountName $storacc).Primary
		$ctx = New-AzureStorageContext -StorageAccountName $storacc -StorageAccountKey $key
		1..50 | % {Set-AzureStorageBlobContent -File 'C:\transcr.txt'  -Container 'testcont' -Blob "file$_.exe" -Context $ctx -force}
	
} -args ($key,$storacc)  -ExecutionPolicy 'Unrestricted'

