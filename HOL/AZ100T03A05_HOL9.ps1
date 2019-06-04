# �Ʒ� ��ũ��Ʈ �������� VM, ���ҽ��׷� �� ������ ��� �غ�Ǿ� �־�� ��.(��� ������ ���ҽ� �׷�ȿ�)

$resourceGroup = "hahaysh-rg2"
$location = "EastUS2"
$vmName = "hahaysh-vm2"
$storageName = "hahayshsta2"

# storage account�����
$storageAccount = New-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageName -Location $location -SkuName "Standard_LRS"

# storage account�� DSC ���� ����
# ps1���� ������ ��ġ�� �̵� : cd C:\CloudDrive\OneDrive\PowerShell 
Publish-AzVMDscConfiguration -ConfigurationPath .\iisInstall.ps1 -ResourceGroupName $resourceGroup -StorageAccountName $storageName -force

# DSC�� VM�� ����
Set-AzVMDscExtension -Version '2.76' -ResourceGroupName $resourceGroup -VMName $vmName -ArchiveStorageAccountName $storageName -ArchiveBlobName 'iisInstall.ps1.zip' -AutoUpdate: $true -ConfigurationName 'IISInstall��