# HealthVaultProviderManagementPortal

Please make sure you've reviewed the [HealthVault Getting Started documentation](https://docs.microsoft.com/en-us/healthvault/getting-started/).

To run this sample: 
1. Make sure you've registered your app in the [Application Config Center](https://config.healthvault-ppe.com/) (ACC).
2. Add the ApplicationId you received in the ACC to the Web.config file. 
    > Note: From a command prompt, you can run the following script to set your ApplicationId quickly. Please replace the ApplicationId below with the value you received. 
    > 
    > ```cmd
    > powershell .\Update-WebConfig.ps1 -ApplicationId "00000000-0000-0000-0000-000000000000"
    ```
3. Make sure the private key for the application is installed on your machine. See how to [create or install a certificate](https://docs.microsoft.com/en-us/healthvault/concepts/connectivity/creating-key-pairs).
4. Build and run the solution.
    * This should automatically restore the HealthVault.NET NuGet package, and all other NuGet packages required by the project.

> Note: Developers outside the US must update the Web.config with the appropriate URLs for their instance. 
> * ShellUrl: "https://account.healthvault-ppe.co.uk/"
> * HealthServiceUrl: "https://platform.healthvault-ppe.co.uk/platform/"
> * RestHealthServiceUrl: "https://platform.healthvault-ppe.co.uk/"
> 
> From a command prompt, you may also run the following script to set your market quickly. 
>
> ```cmd 
> powershell .\Update-WebConfig.ps1 -Instance EU
> ``` 

