<#

.SYNOPSIS
This script can be used to build a HealthVault-compatible X509 certificate and add it to the local machine's certificate store. The certificate will be placed in the current users' Downloads directory and must be uploaded to HealthVault's Pre-production environment before use. 

.EXAMPLE
./Create-HealthVaultCert.ps1 -ApplicationId "00000000-0000-0000-0000-000000000000" 

.PARAMETER ApplicationId
The ApplicationId parameter allows you to specify the GUID value (without braces) which is registered in HealthVault for your app.

#>

param(
[guid]$ApplicationID
)


# https://blogs.technet.microsoft.com/heyscriptingguy/2015/07/29/use-function-to-determine-elevation-of-powershell-console/
function Test-IsAdmin
{
 <#
    .Synopsis
        Tests if the user is an administrator
    .Description
        Returns TRUE if a user is an administrator, FALSE if the user is not an administrator       
    .Example
        Test-IsAdmin
    #>
 $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
 $principal = New-Object Security.Principal.WindowsPrincipal $identity
 $principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}    

function Create-HealthVaultCert([guid]$applicationID) {
    $cert = New-SelfSignedCertificate -DnsName "WildcatApp-$applicationID" -CertStoreLocation "cert:\\LocalMachine\My" -HashAlgorithm "SHA256" -Provider 'Microsoft Enhanced RSA and AES Cryptographic Provider'
    Export-Certificate -Cert $cert -FilePath $env:USERPROFILE\Downloads\${applicationID}.cer
   Set-ReadPermissionsForCert $cert
}

function Set-ReadPermissionsForCert([System.Security.Cryptography.X509Certificates.X509Certificate]$Cert, [string]$Username = $env:USERNAME) {
    $keyPath = "C:\ProgramData\Microsoft\Crypto\RSA\MachineKeys\"
    $fullPath = $keyPath+$Cert.PrivateKey.CspKeyContainerInfo.UniqueKeyContainerName
    $acl = Get-Acl -Path $fullPath
    $permission = $Username,"Read","Allow"
    $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission
    $acl.AddAccessRule($accessRule)
    Set-Acl $fullPath $acl
}

if (Test-IsAdmin -eq $TRUE) {
    Create-HealthVaultCert($ApplicationID)
} else {
    Write-Error -Message "Please relaunch Powershell as an administrator and try again."
}


