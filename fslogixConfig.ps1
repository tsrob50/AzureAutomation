
#Script to set Session Hosts registry keys for Azure AD Joined VM's
#and FSLogix
#https://docs.microsoft.com/en-us/azure/virtual-desktop/create-profile-container-azure-ad


#Logging is handy when you need it!
if ((test-path c:\logfiles) -eq $false) {
    new-item -ItemType Directory -path 'c:\' -name 'logfiles' | Out-Null
} 
$logFile = "c:\logfiles\" + (get-date -format 'yyyyMMdd') + '_softwareinstall.log'

# Logging function
function Write-Log {
    Param($message)
    Write-Output "$(get-date -format 'yyyyMMdd HH:mm:ss') $message" | Out-File -Encoding utf8 $logFile -Append
}

#Session Host Setting
#Enable the Azure AD Kerberos functionality
#Add the key
$name = "CloudKerberosTicketRetrievalEnabled"
$value = "1"
$type = 'DWORD'
#Check and Add Registry Path (should exist)
if (!(Test-Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\Kerberos\Parameters")) {
    try {
        New-Item -ErrorAction Stop -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\Kerberos\Parameters" -Force 
    }
    catch {
        $ErrorMessage = $_.Exception.message
        write-log "Error adding KEY $name : $ErrorMessage"
    }
}
#Set the value
try {
    New-ItemProperty -ErrorAction Stop -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\Kerberos\Parameters" -Name $name -Value $value -PropertyType $type -Force
}
catch {
    $ErrorMessage = $_.Exception.message
    write-log "Error adding Value $name : $ErrorMessage"
}


#Set the credential key to the profile
$name = "LoadCredKeyFromProfile"
$value = "1"
$type = 'DWORD'
# Test and add the registry path (should exist)
if (!(Test-Path "HKLM:\Software\Policies\Microsoft\AzureADAccount")) {
    try {
        New-Item -ErrorAction Stop -Path "HKLM:\Software\Policies\Microsoft\AzureADAccount" -Force 
    }
    catch {
        $ErrorMessage = $_.Exception.message
        write-log "Error adding KEY $name : $ErrorMessage"
    }
}
#Set the value for the key
try {
    New-ItemProperty -ErrorAction Stop -Path "HKLM:\Software\Policies\Microsoft\AzureADAccount" -Name $name -Value $value -PropertyType $type -Force
}
catch {
    $ErrorMessage = $_.Exception.message
    write-log "Error adding Value $name : $ErrorMessage"
}


## FSLogix Settings ##
## https://docs.microsoft.com/en-us/fslogix/profile-container-configuration-reference

# Enable FSLogix
$name = "Enabled"
$value = "1"
$type = 'DWORD'
#Set the value for the key
try {
    New-ItemProperty -ErrorAction Stop -Path "HKLM:\SOFTWARE\FSLogix\Profiles" -Name $name -Value $value -PropertyType $type -Force
}
catch {
    $ErrorMessage = $_.Exception.message
    write-log "Error adding Value $name : $ErrorMessage"
}

# Set the profile locations
$name = "VHDLocations"
$value = "\\ciraadstg03.file.core.windows.net\fslogix\profiles"
$type = 'String'
#Set the value for the key
try {
    New-ItemProperty -ErrorAction Stop -Path "HKLM:\SOFTWARE\FSLogix\Profiles" -Name $name -Value $value -PropertyType $type -Force
}
catch {
    $ErrorMessage = $_.Exception.message
    write-log "Error adding Value $name : $ErrorMessage"
}

# Switch profile directory name
$name = "FlipFlopProfileDirectoryName"
$value = "1"
$type = 'DWORD'
#Set the value for the key
try {
    New-ItemProperty -ErrorAction Stop -Path "HKLM:\SOFTWARE\FSLogix\Profiles" -Name $name -Value $value -PropertyType $type -Force
}
catch {
    $ErrorMessage = $_.Exception.message
    write-log "Error adding Value $name : $ErrorMessage"
}

# Set the VHD(X) to dynamic
$name = "IsDynamic"
$value = "1"
$type = 'DWORD'
#Set the value for the key
try {
    New-ItemProperty -ErrorAction Stop -Path "HKLM:\SOFTWARE\FSLogix\Profiles" -Name $name -Value $value -PropertyType $type -Force
}
catch {
    $ErrorMessage = $_.Exception.message
    write-log "Error adding Value $name : $ErrorMessage"
}

# Set voluem type to .vhdx
$name = "VolumeType"
$value = "vhdx"
$type = 'String'
#Set the value for the key
try {
    New-ItemProperty -ErrorAction Stop -Path "HKLM:\SOFTWARE\FSLogix\Profiles" -Name $name -Value $value -PropertyType $type -Force
}
catch {
    $ErrorMessage = $_.Exception.message
    write-log "Error adding Value $name : $ErrorMessage"
}

# Redirect Teams temp data to local profile, stop Teams bloat
$name = "RedirXMLSourceFolder"
$value = "\\ciraadstg03.file.core.windows.net\fslogix\fslogixtools"
$type = 'String'
#Set the value for the key
try {
    New-ItemProperty -ErrorAction Stop -Path "HKLM:\SOFTWARE\FSLogix\Profiles" -Name $name -Value $value -PropertyType $type -Force
}
catch {
    $ErrorMessage = $_.Exception.message
    write-log "Error adding Value $name : $ErrorMessage"
}
