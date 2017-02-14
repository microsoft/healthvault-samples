# HealthVault Meaningful Use Reporting Sample

This sample serves as a demonstration of HealthVault capabilities in support of Meaningful Use Stage 2 (2014 Edition) patient engagement objectives.  Refer to [Meaningful Use with HealthVault](http://msdn.microsoft.com/en-us/library/dn539122.aspx) for an overview and technical description of the HealthVault capabilities that support Meaningful Use 2. 

## Scenarios
This sample demonstrates the following scenarios: 
* Send CCDAs to HealthVault users with the **DOPU** approach and retrieve corresponding VDT reports.  
* Establish an **offline record authorization** from a website, send CCDAs to HealthVault with this connection, and retrieve corresponding VDT reports. 
* Send CCDAs to HealthVault users with **Direct Messaging** (performed outside of the sample itself), and use the sample to retrieve corresponding VDT reports.  
* **Retrieve VDT** reports for a specified reporting period.  
* **Override** the patient ID and event date (visit or discharge date) when sending CCDAs to HealthVault. 

![Screenshot from app sample](images/report2.png?raw=true)

## Building and running the sample
1. Download the sample file to a location on your computer.
2. Install the [HealthVault .NET SDK](https://go.microsoft.com/fwlink/?linkid=838835)
3. Launch the HealthVault Application Manager and Create a new application
4. Provide a name for the application, uncheck "Automatically create Visual Studio website", and click to create and register the application. This opens a browser to the HealthVault Application Configuration Center (ACC).
5. Sign-in to ACC to create the application in the HealthVault PPE environment. Find your application in the app list and click the application ID. Browse to the "Methods" tab, select the following, and save:
    * "Application requires access to Meaningful Use reports"
    * "Application requires access to ConnectPackage methods."
6. Next navigate to the "Offline Rules" tab. Create a new offline rule. Enter a value for the rule name (Ex. "Send CCDAs") and why string (Ex. "Access needed to send CCDAs to HealthVault"). Leave the Is Optional and Display flags unchecked. Under Permissions select "Create". Under Data Types, find and select "Continuity of Care (CCD)" Scroll down and save your changes.
7. Switch back to the HealthVault Application Manager on your computer. Right-click your newly created application and:
8. Click "Export public and private keys (.pfx)" and save the PFX file to a location on your machine. Next, right-click your application and click "Copy Application ID to clipboard".
9. Open the sample solution file, then open the Web.config file and:
    * Paste the Application ID you copied earlier into the "ApplicationId" configuration.
    * For the "ApplicationCertificateFileName" configuration specify the full path to the PFX file you saved earlier.
10. You'll now have entries in your web.confg file that look like:   
```xml
<add key="ApplicationId" value="6bf02176-0832-4b90-9c87-c0282cecf0ac" /> 
<add key="ApplicationCertificateFileName" value="C:\dev\MyMU2Sample.pfx" /> 
```
    
    
11. In Visual Studio right click your project and select "Add Reference". Browse to the location of the HealthVault .NET SDK DLLs (typically : Program Files (x86)\Microsoft HealthVault\SDK\DotNet\Assemblies) and add references to:
    *  Microsoft.Health.dll
    * Microsoft.Health.ItemTypes.dll
    * Microsoft.Health.Web.dll
12. Hit F5 to run the sample 

## Source Code Files
* Default.aspx - The main ASP.NET markup for the sample 
* Default.aspx.cs - The primary code-behind file for the sample 

