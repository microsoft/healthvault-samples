# HealthVault Client Application Sample

This sample application demonstrates creating a client application that works 
with HealthVault. 

It demonstrates the following functionality
- How to setup/provision an application using the SODA authentication pattern.
- How to make a connection to HealthVault and get/set data.

## Details of the sample:

### Files
**HVClient.cs**: This is of most interest as it contains the majority
of the code to setup the application and retrieve data.

**MainForm.cs**: Code for the form that does user interface. This calls into
HVClient to do most of the application setup and retrieval.

**Program.cs**: Default Visual Studio generated code to launch application


### HVClient
The public methods such as ProvisionApplication(), DeProvision(), GetWeightFromHealthVault() 
and SetWeightOnHealthVault().

ProvisionApplication illustrates application setup steps. An application would
provision itself on first use or at setup time. Once the application is 
provisioned, subsequent connections to HealthVault need only the creation 
of SDK objects for HealthClientApplication and HealthClientAuthorizedConnection.

DeProvision illustrates how an application can clean up if removed from the user's machine.
It deauthorizes the application from HealthVault. It also deletes the local 
certificate that is used for making a client connection to HealthVault.

GetWeightFromHealthVault() and SetWeightOnHealthVault(): These methods show how 
a HealthClientAuthorizedConnection can be created and used for working with
items on HealthVault.