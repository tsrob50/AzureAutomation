# Get Credentials
$creds = Get-AutomationPSCredential -Name "<Shared_Credential_Name>"

# Windows AD Command
write-output "Group Members"
Get-ADGroupMember '<Target_Group_Name>' -Credential $creds | select name

# Computer Name 
Write-output "Computer Names"
$computers = “<Computer1>”,”<Computer2>”,”<Computer3>”
invoke-command -ComputerName $computers -Credential $creds -ScriptBlock {
    write-output "Computer Name:"
    $env:COMPUTERNAME
}

# Test and Create a Folder
write-output "Test and Create a Folder"
$targets = “<Computer1>”,”<Computer2>”,”<Computer3>”
invoke-command -ComputerName $targets -Credential $creds -ScriptBlock {
    $path = Test-Path -path c:\logs
    if ($path) {
        Write-Output "Computer $env:COMPUTERNAME has the logs folder"
    }
    else {
        Write-output "Creating logs folder on $env:COMPUTERNAME"
        New-Item -path "c:\" -Name "logs" -ItemType Directory
    }
}
