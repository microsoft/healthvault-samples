# healthvault-ios-sdk

[![CI Status](https://microsofthealth.visualstudio.com/_apis/public/build/definitions/f8da5110-49b1-4e9f-9022-2f58b6124ff9/194/badge)]
[![Version](https://img.shields.io/cocoapods/v/healthvault-ios-sdk.svg?style=flat)](http://cocoapods.org/pods/healthvault-ios-sdk)
[![License](https://img.shields.io/cocoapods/l/healthvault-ios-sdk.svg?style=flat)](http://cocoapods.org/pods/healthvault-ios-sdk)
[![Platform](https://img.shields.io/cocoapods/p/healthvault-ios-sdk.svg?style=flat)](http://cocoapods.org/pods/healthvault-ios-sdk)

# About

**healthvault-ios-sdk** is an iOS framework you can use to build applications that leverage the Microsoft HealthVault platform. **healthvault-ios-sdk** is actively used by the [Microsoft HealthVault for iPhone app](https://itunes.apple.com/us/app/microsoft-healthvault/id546835834?mt=8).

HealthVault data types are automatically serialized/deserialized into Objective-C objects. These objects include programming model to assist with data manipulation. 

## Example

The example project demonstrates how to:

* Authenticate with HealthVault.
* View, create, update and delete most core HealthVault types, including blood pressure, medication, conditions, procedures, immunizations, blood glucose, exercise and diet.
* manage files - view, download and upload files in HealthVault.
* de-authorize your application from HealthVault.

## Installation

### Using CocoaPods

The healthvault-ios-sdk is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "healthvault-ios-sdk"
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

# Contribute
Contributions to the **healthvault-ios-sdk** are welcome.  Here is how you can contribute:

* [Submit bugs](https://github.com/Microsoft/HVMobile_VNext/issues) and help us verify fixes
* [Submit pull requests](https://github.com/Microsoft/HVMobile_VNext/pulls) for bug fixes and features

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/). For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
