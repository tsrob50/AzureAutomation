#Script to run Sysprep on a VM
if ((test-path c:\logfiles) -eq $false) {
    new-item -ItemType Directory -path 'c:\' -name 'logfiles' | Out-Null
} 
$logFile = "c:\logfiles\" + (get-date -format 'yyyyMMdd') + '_softwareinstall.log'

function Write-Log {
    Param($message)
    Write-Output "$(get-date -format 'yyyyMMdd HH:mm:ss') $message" | Out-File -Encoding utf8 $logFile -Append
}
#Disable Auto Updates, updates stop Sysprep
try {
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name NoAutoUpdate -Value 1
}
catch {
    $ErrorMessage = $_.Exception.message
    write-log "Error running Sysprep: $ErrorMessage"
}
#Run Sysprep
try{
    write-output "Sysprep Starting"
    Start-Process -filepath 'c:\Windows\system32\sysprep\sysprep.exe' -Wait ERROR -ErrorAction Stop -ArgumentList  '/shutdown', '/oobe', '/mode:vm', '/quiet'
    write-output "Sysprep Started"
}
catch {
    $ErrorMessage = $_.Exception.message
    write-log "Error running Sysprep: $ErrorMessage"
}
