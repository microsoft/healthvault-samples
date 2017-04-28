# HealthVault UWP Sample

## Running the sample

1. Make sure you've registered your app in the [Application Config Center](https://config.healthvault-ppe.com/) (ACC).
  1. Choose SODA authentication method
  2. You will need to add permission for the following data types:
    * Weight
    * PersonalImage
    * BasicV2
    * Medications
    * BloodGlucose
    * BloodPressure
    * CholesterolProfile
    * LabTestResults
    * Immunization
    * Procedure
    * Allergy
    * Condition
2. Add the ApplicationId you received in the ACC to the app.config file. 
    > Note: From a command prompt, you can run the following script to set your ApplicationId quickly. Please replace the ApplicationId below with the value you received. 
    > 
    > ```cmd
    > powershell .\Update-AppConfig.ps1 -ApplicationId "00000000-0000-0000-0000-000000000000"
    ```
3. Build and run the solution.
    * This should automatically restore the HealthVault .NET Standard SDK NuGet package, and all other NuGet packages required by the project.

> Note: Developers outside the US must update the Web.config with the appropriate URLs for their instance. 
> * ShellUrl: "https://account.healthvault-ppe.co.uk/"
> * HealthServiceUrl: "https://platform.healthvault-ppe.co.uk/platform/"
> * RestHealthServiceUrl: "https://platform.healthvault-ppe.co.uk/"
> 
> From a command prompt, you may also run the following script to set your market quickly. 
>
> ```cmd 
> powershell .\Update-AppConfig.ps1 -Instance EU
> ``` 

