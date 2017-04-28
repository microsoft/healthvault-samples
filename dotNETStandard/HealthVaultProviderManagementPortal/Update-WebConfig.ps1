<#

.SYNOPSIS
This script can be used to quickly edit the Web.config file for your sample. 

.EXAMPLE
./Update-WebConfig.ps1 -ApplicationId "00000000-0000-0000-0000-000000000000" -Instance US

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

$webConfigPath = $PSScriptRoot + "\HealthVaultProviderManagementPortal\Web.config"
[xml] $webConfigXml = Get-Content -Path $webConfigPath -Raw
$defaultApplicationId = "your application ID here";

if ($Reset) {
    ($webConfigXml | Select-Xml -XPath "//add[@key='HV_ApplicationId']/@value").Node.InnerText = $defaultApplicationId;
}
elseif ($ApplicationId) {
    ($webConfigXml | Select-Xml -XPath "//add[@key='HV_ApplicationId']/@value").Node.InnerText = $ApplicationId
}

switch ($Instance) {
    
    'US' {
        ($webConfigXml | Select-xml -XPath "//add[@key='HV_ShellUrl']/@value").Node.InnerText = "https://account.healthvault-ppe.com/"
        ($webConfigXml | Select-xml -XPath "//add[@key='HV_HealthServiceUrl']/@value").Node.InnerText = "https://platform.healthvault-ppe.com/platform/"
        ($webConfigXml | Select-xml -XPath "//add[@key='HV_RestHealthServiceUrl']/@value").Node.InnerText = "https://data.ppe.microsofthealth.net"
    }

    'EU' {
        ($webConfigXml | Select-xml -XPath "//add[@key='HV_ShellUrl']/@value").Node.InnerText = "https://account.healthvault-ppe.co.uk/"
        ($webConfigXml | Select-xml -XPath "//add[@key='HV_HealthServiceUrl']/@value").Node.InnerText = "https://platform.healthvault-ppe.co.uk/platform/"
        ($webConfigXml | Select-xml -XPath "//add[@key='HV_RestHealthServiceUrl']/@value").Node.InnerText = "https://data.ppe.microsoft.health.co.uk"
    }
}

$webConfigXml.Save($webConfigPath)
