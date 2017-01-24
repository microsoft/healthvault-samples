To run the sample app:

1. Create a directory C:\HealthVault.NET
2. You should have received a healthvault.net nupkg. Copy it to this directory.
3. Open HealthVaultProviderManagementPortal.sln in Visual Studio. (You may need to run Visual Studio as administrator.)
4. Tell the NuGet package manager about your local package:
    4a. In Visual Studio, go to Tools > NuGet Package Manager > Package Manager Settings
    4b. In the left pane, select NuGet Package Manager > Package Sources
    4c. In the right pane, select the plus symbol.
    4d. Enter the following:
        Name: HealthVault.NET
        Package source: C:\HealthVault.NET
    4e. Click Update
    4f. Click OK.
5. In the web.config, update the ApplicationId setting to the ID for the application you created in ACC.
6. Make sure the private key for the application is installed on your machine. (See section 4.2 in the Getting Started document.)
7. Build and run the solution.
    -> This should automatically restore the HealthVault.NET NuGet package, and all other NuGet packages required by the project.
