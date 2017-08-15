# Introduction 
Microsoft HealthVault is a cloud-based platform designed to put people in control of their health data. This repository hosts samples of apps and sites which allow developers to provide additional value on the HealthVault platform. 

For more information on HealthVault for developers, please see our comprehensive [developer documentation](https://go.microsoft.com/fwlink/?linkid=838955). 


# Getting Started

## SDKs
HealthVault offers SDKs for many platforms. 
* .NET
  * [Nuget package](https://www.nuget.org/packages/HealthVault.NET/) - Easily stay up-to-date with the latest HealthVault SDK by leveraging the .NET SDK published via Nuget.
  * [MSI download](https://www.microsoft.com/downloads/details.aspx?FamilyID=95e14343-fb98-4549-bd29-225a59423cc9) - Optional. Offers some additional tools, including the HealthVault Application Manager.  
* [Java/Android](http://healthvaultjavalib.codeplex.com/) - Maven-enabled SDK for Java and Android app development. 
* [iOS](https://github.com/microsoft-hsg/HVMobile_VNext) - Objective-C SDK for iOS app development
* [HealthVault Device Driver Development Kit](https://www.microsoft.com/en-us/download/details.aspx?id=26801) - A DDK for device manufacturers developing HealthVault-enabled devices for Windows. 

* Third-party libraries
  * [Drupal](https://www.drupal.org/project/healthvault_connect) - A Drupal connector for HealthVault
  * [PHP](http://mkalkbrenner.github.io/HVClientLibPHP/) - An open-source library for developing HealthVault-enabled applications in PHP. 
  * [Python](https://github.com/orcasgit/python-healthvault) - An open-source library for developing HealthVault-enabled applications in Python.
  * [Ruby](http://healthvaultrubylib.codeplex.com/) - An open-source library for developing HealthVault-enabled applications in Ruby. 

## Samples
* .NET Standard (Preview)
  * **HealthVault-uwp** - The HealthVault-uwp sample demonstrates the basics of accessing and modifying several kinds of HealthVault data types using the .NET Standard SDK. 
  * **HealthVaultProviderManagementPortal** - This sample demonstrates how a provider could invite patients and manage ActionPlans. 
* .NET
  * **HealthVault - Your Web Service - Your Client apps** - The HealthVault Proxy Service exposes three primary service-interfaces for client apps. These interfaces correspond to HealthVault feature areas. Specifically, Patient Connect, Get/Put Things, and DOPU. Learn more about HealthVault solution architectures at the Health Team Blog.
  * **HealthVault Meaningful Use Reporting** - This sample serves as a demonstration of HealthVault capabilities in support of Meaningful Use Stage 2 (2014 Edition) patient engagement objectives. Refer to Meaningful Use with HealthVault for an overview and technical description of the HealthVault capabilities that support Meaningful Use 2. 
  * **HealthVaultProviderManagementPortal** - This sample demonstrates how a provider could invite patients and manage ActionPlans. 
  * **HVClientSample** - This sample demonstrates how to use SODA authentication to access data on HealthVault. 

## Tools
* PowerShell
  * **Create-HealthVaultCertificate** - This tool creates a valid certificate for HealthVault using the ApplicationID that you provide. The certificate is automatically added to your LocalMachine's certificate store, and a copy is placed in your user's Downloads folder. 

## Registering your applications
All applications must be registered with the [HealthVault Application Configuration Center](https://go.microsoft.com/fwlink/?linkid=838954) before they can connect to the service. During registration, the ACC will request that you upload an appropriate certificate which will be used subsequently to secure communications between your app and the service. For more information on how to obtain an appropriate certificate, please see [Creating Key Pairs](https://docs.microsoft.com/en-us/healthvault/concepts/connectivity/creating-key-pairs). 

# Contribute
Contributions to healthvault-samples are welcome.  Here is how you can contribute:

* [Submit bugs](https://github.com/Microsoft/healthvault-samples/issues) and help us verify fixes
* [Submit pull requests](https://github.com/Microsoft/healthvault-samples/pulls) for bug fixes and features

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/). For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
