# healthvault-ios-sdk

[![CI Status](https://microsofthealth.visualstudio.com/_apis/public/build/definitions/f8da5110-49b1-4e9f-9022-2f58b6124ff9/194/badge)]
[![Version](https://img.shields.io/cocoapods/v/HealthVault.svg?style=flat)](https://cocoapods.org/pods/HealthVault)
[![License](https://img.shields.io/cocoapods/l/HealthVault.svg?style=flat)](https://cocoapods.org/pods/HealthVault)
[![Platform](https://img.shields.io/cocoapods/p/HealthVault.svg?style=flat)](https://cocoapods.org/pods/HealthVault)

# About

**healthvault-ios-sdk** is an iOS framework you can use to build applications that leverage the Microsoft HealthVault platform. **healthvault-ios-sdk** is actively used by the [Microsoft HealthVault for iPhone app](https://itunes.apple.com/us/app/microsoft-healthvault/id546835834?mt=8).

### Features

* Handling of user authentication and secure credential storage. 
* Serialization/Deserialization of all HeathVault data types.
* Caching and offline support for HealthVault Thing types.

## Example

The example project demonstrates how to:

* Authenticate with HealthVault.
* View, create, update and delete most core HealthVault types, including blood pressure, medication, conditions, procedures, immunizations, blood glucose, exercise and diet.
* manage files - view, download and upload files in HealthVault.
* De-authorize your application from HealthVault.

## Installation

### Using CocoaPods

The healthvault-ios-sdk is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "HealthVault"
```

If offline support and caching for HealthVault Thing types is not needed, you can install just the 'Core' subspec. This will remove the dependencies on EncryptedCoreData and SQLCipher.

```ruby
pod "HealthVault/Core"
```

### Using Carthage

Add this line to your Cartfile:

```ruby
github "Microsoft/healthvault-ios-sdk"
```

and then follow the steps described in the [Carthage documentation](https://github.com/Carthage/Carthage#if-youre-building-for-ios-tvos-or-watchos).

## Setup

### Objective-C

```objectivec
@import HealthVault;
```

### Swift

```swift
import HealthVault
```

## Registering your applications
All applications must be registered with the [HealthVault Application Configuration Center](https://go.microsoft.com/fwlink/?linkid=838954) (ACC) before they can connect to the service. During registration, the ACC will request that you upload an appropriate certificate which will be used subsequently to secure communications between your app and the service. For more information on how to obtain an appropriate certificate, please see [Creating Key Pairs](https://docs.microsoft.com/en-us/healthvault/concepts/connectivity/creating-key-pairs). 

# Contribute
Contributions to the **healthvault-ios-sdk** are welcome.  Here is how you can contribute:

* [Submit bugs](https://github.com/Microsoft/healthvault-ios-sdk/issues) and help us verify fixes
* [Submit pull requests](https://github.com/Microsoft/healthvault-ios-sdk/pulls) for bug fixes and features

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/). For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
