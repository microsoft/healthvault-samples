<#

.SYNOPSIS
This script can be used to quickly edit the Web.config file for your sample. 

.EXAMPLE
./Update-WebConfig.ps1 -ApplicationID "00000000-0000-0000-0000-000000000000" -Region US

.PARAMETER Reset
The Reset parameter restores this file back to the state which is required by GitHub to protect your app's ApplicationId.

.PARAMETER ApplicationID
The ApplicationId parameter allows you to specify the GUID value (without braces) which is registed in HealthVault for your app.

#>

Param
(
[switch] $Reset,
[string] $ApplicationID
)

$webConfigPath = $PSScriptRoot + "\HealthVaultProviderManagementPortal\Web.config"
$webConfigXml = (select-xml -Path $webConfigPath -XPath "/").Node
$defaultApplicationId = "your application ID here";

if ($Reset.IsPresent) {
    ($webConfigXml | Select-Xml -XPath "//add[@key='ApplicationId']").Node.Attributes.GetNamedItem("value").InnerText = $defaultApplicationId;
    $webConfigXml.Save($webConfigPath)
}

if ($ApplicationID -ne $null -and $ApplicationID -ne "") {
    ($webConfigXml | Select-Xml -XPath "//add[@key='ApplicationId']").Node.Attributes.GetNamedItem("value").InnerText = $ApplicationID
    $webConfigXml.Save($webConfigPath)
}


