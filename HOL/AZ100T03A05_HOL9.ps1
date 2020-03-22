# 아래 스크립트 진행전에 VM, 리소스그룹 이 사전에 모두 준비되어 있어야 됨.(모두 동일한 리소스 그룹안에)

$resourceGroup = "hahaysh-rg2"
$location = "EastUS2"
$vmName = "hahaysh-vm2"
$storageName = "hahayshsta2"

# storage account만들기
$storageAccount = New-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageName -Location $location -SkuName "Standard_LRS"

# storage account에 DSC 파일 배포
# ps1파일 저장한 위치로 이동 : cd C:\CloudDrive\OneDrive\PowerShell 
Publish-AzVMDscConfiguration -ConfigurationPath .\iisInstall.ps1 -ResourceGroupName $resourceGroup -StorageAccountName $storageName -force

# DSC를 VM에 적용
Set-AzVMDscExtension -Version '2.76' -ResourceGroupName $resourceGroup -VMName $vmName -ArchiveStorageAccountName $storageName -ArchiveBlobName 'iisInstall.ps1.zip' -AutoUpdate: $true -ConfigurationName 'IISInstall’
