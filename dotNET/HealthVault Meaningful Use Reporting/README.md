# HealthVault Meaningful Use Reporting Sample

This sample serves as a demonstration of HealthVault capabilities in support of Meaningful Use Stage 2 (2014 Edition) patient engagement objectives.  Refer to [Meaningful Use with HealthVault](https://docs.microsoft.com/en-us/healthvault/scenarios/meaningful-use) for an overview and technical description of the HealthVault capabilities that support Meaningful Use 2. 

## Scenarios
This sample demonstrates the following scenarios: 
* Send CCDAs to HealthVault users with the **DOPU** approach and retrieve corresponding VDT reports.  
* Establish an **offline record authorization** from a website, send CCDAs to HealthVault with this connection, and retrieve corresponding VDT reports. 
* Send CCDAs to HealthVault users with **Direct Messaging** (performed outside of the sample itself), and use the sample to retrieve corresponding VDT reports.  
* **Retrieve VDT** reports for a specified reporting period.  
* **Override** the patient ID and event date (visit or discharge date) when sending CCDAs to HealthVault. 

## Building and running the sample
1. Clone the sample to a location on your computer.
2. Navigate to the [HealthVault Application Configuration Center](https://config.healthvault-ppe.com) (ACC)
3. Create a new application and select Web authentication mode. 
4. Create a certificate using one of the following commands. 
    * [Recommended, requires Windows 10+] From an administrative command prompt, navigate to your repository's root directory, then run the following command, substituting the applicationID you received from the ACC. 
      ```cmd
        powershell .\powershell\Create-HealthVaultCert.ps1 -ApplicationID "00000000-0000-0000-0000-000000000000"
      ```
    * From an administrative, developer command prompt: 
      ```cmd
      makecert -a sha256 -n "CN=WildcatApp-00000000-0000-0000-0000-000000000000" -sr LocalMachine -ss My -sky signature -pe -len 2048 "D:\Fabrikam-Test-Cert.cer"
      ```
5. Create your application, then click on the ApplicationID to edit the details.  Browse to the "Methods" tab, select the following, and save:
    * "Application requires access to Meaningful Use reports"
    * "Application requires access to ConnectPackage methods."
6. Next navigate to the "Offline Rules" tab. Create a new offline rule. Enter a value for the rule name (Ex. "Send CCDAs") and why string (Ex. "Access needed to send CCDAs to HealthVault"). Leave the Is Optional and Display flags unchecked. Under Permissions select "Create". Under Data Types, find and select "Continuity of Care (CCD)" Scroll down and save your changes.
7. Add the ApplicationId you received in the ACC to the Web.config file in the app. 
    > Note: From a command prompt, you can run the following script to set your ApplicationId quickly. Please replace the ApplicationId below with the value you received. 
    > 
    > ```cmd
    > powershell .\Update-WebConfig.ps1 -ApplicationId "00000000-0000-0000-0000-000000000000"
    ```
8. You'll now have an entry in your web.confg file that looks like:   
```xml
<add key="ApplicationId" value="6bf02176-0832-4b90-9c87-c0282cecf0ac" /> 
```
9. Hit F5 to run the sample 


