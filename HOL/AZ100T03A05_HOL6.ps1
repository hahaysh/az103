#먼저 로그인
Connect-AzAccount

#VME목록
Get-AzVmImagePublisher -Location "EastUS2" | `
Get-AzVMExtensionImageType | `
Get-AzVMExtensionImage | Select Type, Version

#VME관련 Command확인
Get-Command Set-Az*Extension* -Module Az.Compute

#VM에 VME에이전트가 설치되어 있는지 확인
$vms = Get-AzVM
foreach ($vm in $vms) {
    $agent = $vm | Select -ExpandProperty OSProfile | Select -ExpandProperty Windowsconfiguration | Select ProvisionVMAgent
    Write-Host $vm.Name $agent.ProvisionVMAgent
}

#리소스그룹과 가상머신이름 정의
$ResourceName = "hahaysh-rg2"
$vmName = "hahaysh-vm2"

#CustomScriptExtension 을 이용해 Github에서 파워셀 스크립트를 다운 받아서 실행 - 해당 파일을 직접 접근해서 무슨일을 하는지 확인해본다.
#미리 원격서버에 접속해서 파일이 만들어지는지 지켜본다.

#IIS구성 - 원격파일을 통해서 
#Set-AzVMCustomScriptExtension -ResourceGroupName $ResourceName `
#    -VMName $vmName -Name "myScript" `
#    -FileUri "https://raw.githubusercontent.com/neilpeterson/nepeters-azure-templates/master/windows-custom-script-simple/support-scripts/Create-File.ps1" `
#    -Run "Create-File.ps1" -Location "East US2"

#IIS구성
#  Uninstall-WindowsFeature -Name Web-Server 
Set-AzVMExtension -ResourceGroupName $ResourceName `
    -ExtensionName "myScript" `
    -VMName $vmName `
    -Location "EastUS2" `
    -Publisher Microsoft.Compute `
    -ExtensionType CustomScriptExtension `
    -TypeHandlerVersion 1.8 `
    -SettingString '{"commandToExecute":"powershell Add-WindowsFeature Web-Server; powershell Add-Content -Path \"C:\\inetpub\\wwwroot\\Default.htm\" -Value $($env:computername)"}'

#VM에 배포된 VME 목록 나열
$vm = Get-AzVM -ResourceGroupName $ResourceName -VMName $vmName
$vm.Extensions | select Publisher, VirtualMachineExtensionType, TypeHandlerVersion

#VME상태 보기 
Get-AzVM -ResourceGroupName $ResourceName -VMName $vmName -Status

# VM의 웹서버로 접근해서 페이지가 뜨는지 확인

#VME제거 - 포탈에서 먼저 설치된 것을 확인한 후에 삭제(포탈에서는 확인이 늦음)
Remove-AzVMExtension -ResourceGroupName $ResourceName -VMName $vmName -Name "myScript“

===========================================
# PowerShell로 VME구성(간단버전)
Set-AzVMExtension -ResourceGroupName "myResourceGroupAutomate" `
    -ExtensionName "IIS" `
    -VMName "myVM" `
    -Location "EastUS" `
    -Publisher Microsoft.Compute `
    -ExtensionType CustomScriptExtension `
    -TypeHandlerVersion 1.8 `
    -SettingString '{"commandToExecute":"powershell Add-WindowsFeature Web-Server; powershell Add-Content -Path \"C:\\inetpub'

