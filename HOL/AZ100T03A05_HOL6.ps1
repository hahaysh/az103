#���� �α���
Connect-AzAccount

#VME���
Get-AzVmImagePublisher -Location "EastUS2" | `
Get-AzVMExtensionImageType | `
Get-AzVMExtensionImage | Select Type, Version

#VME���� CommandȮ��
Get-Command Set-Az*Extension* -Module Az.Compute

#VM�� VME������Ʈ�� ��ġ�Ǿ� �ִ��� Ȯ��
$vms = Get-AzVM
foreach ($vm in $vms) {
    $agent = $vm | Select -ExpandProperty OSProfile | Select -ExpandProperty Windowsconfiguration | Select ProvisionVMAgent
    Write-Host $vm.Name $agent.ProvisionVMAgent
}

#���ҽ��׷�� ����ӽ��̸� ����
$ResourceName = "hahaysh-rg2"
$vmName = "hahaysh-vm2"

#CustomScriptExtension �� �̿��� Github���� �Ŀ��� ��ũ��Ʈ�� �ٿ� �޾Ƽ� ���� - �ش� ������ ���� �����ؼ� �������� �ϴ��� Ȯ���غ���.
#�̸� ���ݼ����� �����ؼ� ������ ����������� ���Ѻ���.

#IIS���� - ���������� ���ؼ� 
#Set-AzVMCustomScriptExtension -ResourceGroupName $ResourceName `
#    -VMName $vmName -Name "myScript" `
#    -FileUri "https://raw.githubusercontent.com/neilpeterson/nepeters-azure-templates/master/windows-custom-script-simple/support-scripts/Create-File.ps1" `
#    -Run "Create-File.ps1" -Location "East US2"

#IIS����
#  Uninstall-WindowsFeature -Name Web-Server 
Set-AzVMExtension -ResourceGroupName $ResourceName `
    -ExtensionName "myScript" `
    -VMName $vmName `
    -Location "EastUS2" `
    -Publisher Microsoft.Compute `
    -ExtensionType CustomScriptExtension `
    -TypeHandlerVersion 1.8 `
    -SettingString '{"commandToExecute":"powershell Add-WindowsFeature Web-Server; powershell Add-Content -Path \"C:\\inetpub\\wwwroot\\Default.htm\" -Value $($env:computername)"}'

#VM�� ������ VME ��� ����
$vm = Get-AzVM -ResourceGroupName $ResourceName -VMName $vmName
$vm.Extensions | select Publisher, VirtualMachineExtensionType, TypeHandlerVersion

#VME���� ���� 
Get-AzVM -ResourceGroupName $ResourceName -VMName $vmName -Status

#VME���� - ��Ż���� ���� ��ġ�� ���� Ȯ���� �Ŀ� ����(��Ż������ Ȯ���� ����)
Remove-AzVMExtension -ResourceGroupName $ResourceName -VMName $vmName -Name "myScript��

===========================================
# PowerShell�� VME����(���ܹ���)
Set-AzVMExtension -ResourceGroupName "myResourceGroupAutomate" `
    -ExtensionName "IIS" `
    -VMName "myVM" `
    -Location "EastUS" `
    -Publisher Microsoft.Compute `
    -ExtensionType CustomScriptExtension `
    -TypeHandlerVersion 1.8 `
    -SettingString '{"commandToExecute":"powershell Add-WindowsFeature Web-Server; powershell Add-Content -Path \"C:\\inetpub'

