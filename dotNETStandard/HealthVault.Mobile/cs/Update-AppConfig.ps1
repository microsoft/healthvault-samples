<#

.SYNOPSIS
This script can be used to quickly edit the app.config file for your sample. 

.EXAMPLE
./Update-AppConfig.ps1 -ApplicationId "00000000-0000-0000-0000-000000000000" -Instance US

.PARAMETER Reset
The Reset parameter restores this file back to the state which is required by GitHub to protect your app's ApplicationId.

.PARAMETER ApplicationId
The ApplicationId parameter allows you to specify the GUID value (without braces) which is registed in HealthVault for your app.

.PARAMETER Instance
The Instance parameter allows you to specify the appropriate server instances for HealthVault.

#>

Param
(
    [switch] $Reset,

    [guid] $ApplicationId,

    [ValidateSet('US', 'EU', IgnoreCase = $true)]
    [string] $Instance
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$appConfigPath = $PSScriptRoot + "\UWP\app.config"
$jsonConfigPath = $PSScriptRoot + "\Xamarin.Core\Config.json"
[xml] $appConfigXml = Get-Content -Path $appConfigPath -Raw
$appConfigJson = Get-Content -Path $jsonConfigPath | ConvertFrom-Json

$defaultApplicationId = "your application ID here";

if ($Reset) {
    ($appConfigXml | Select-Xml -XPath "//add[@key='ApplicationId']/@value").Node.InnerText = $defaultApplicationId;
    $appConfigJson.MasterApplicationId = $defaultApplicationId
}
elseif ($ApplicationId) {
    ($appConfigXml | Select-Xml -XPath "//add[@key='ApplicationId']/@value").Node.InnerText = $ApplicationId
    $appConfigJson.MasterApplicationId = $ApplicationId
}

switch ($Instance) {
    
    'US' {
        ($appConfigXml | Select-xml -XPath "//add[@key='ShellUrl']/@value").Node.InnerText = "https://account.healthvault-ppe.com/"
        $appConfigJson.DefaultHealthVaultShellUrl = "https://account.healthvault-ppe.com/"
        ($appConfigXml | Select-xml -XPath "//add[@key='HealthServiceUrl']/@value").Node.InnerText = "https://platform.healthvault-ppe.com/platform/"
        $appConfigJson.DefaultHealthVaultUrl = "https://platform.healthvault-ppe.com/platform/"
        ($appConfigXml | Select-xml -XPath "//add[@key='RestHealthServiceUrl']/@value").Node.InnerText = "https://data.ppe.microsofthealth.net"
        $appConfigJson.RestHealthVaultUrl = "https://data.ppe.microsofthealth.net"
    }

    'EU' {
        ($appConfigXml | Select-xml -XPath "//add[@key='ShellUrl']/@value").Node.InnerText = "https://account.healthvault-ppe.co.uk/"
        $appConfigJson.DefaultHealthVaultShellUrl = "https://account.healthvault-ppe.co.uk/"
        ($appConfigXml | Select-xml -XPath "//add[@key='HealthServiceUrl']/@value").Node.InnerText = "https://platform.healthvault-ppe.co.uk/platform/"
        $appConfigJson.DefaultHealthVaultUrl = "https://platform.healthvault-ppe.co.uk/platform/"
        ($appConfigXml | Select-xml -XPath "//add[@key='RestHealthServiceUrl']/@value").Node.InnerText = "https://data.ppe.microsoft.health.co.uk"
        $appConfigJson.RestHealthVaultUrl = "https://data.ppe.microsoft.health.co.uk"
    }
}

$appConfigXml.Save($appConfigPath)
ConvertTo-Json $appConfigJson | Out-File $jsonConfigPath
