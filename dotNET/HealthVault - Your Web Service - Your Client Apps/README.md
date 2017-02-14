# Introduction

Cloud hosted services such as HealthVault, Windows Azure, Office365, Dynamics Online, and others provide a great canvas upon which to compose both consumer and enterprise solutions.   This code-sample, with corresponding documentation, illustrates the use of a Windows Azure hosted web-service to encapsulate specific HealthVault platform services and subsequently exposes those services to a variety of client application types.   The concept isolates HealthVault SDK dependencies and thus frees client-apps to work with whatever service-model (e.g. SOAP, REST) and data-model (e.g. XML, JSON) desired.

The HealthVault Proxy Service exposes three primary service-interfaces for client apps. These interfaces correspond to HealthVault feature areas. Specifically, Patient Connect, Get/Put Things, and DOPU. Learn more about HealthVault solution architectures at the [Health Team Blog](http://blogs.msdn.com/b/healthvault/archive/2013/05/18/revisiting-connectivity-models-and-solutions-architectures.aspx).

![Screenshot from app sample](images/0.HvProxyConfig-0-1.png?raw=true)

## Building the Sample
The attached source file is a Visual Studio 2012 solution. You will also need the [.NET HealthVault SDK](https://go.microsoft.com/fwlink/?linkid=838835). Complete development, build/test, and deployment instructions are provided via this [blog post](https://blogs.msdn.microsoft.com/healthvault/2013/06/02/healthvault-your-web-service-your-client-apps/). 

## Description
Example Service/Client Interface.   The following code-snippet illustrates both the server and client interface implementation of the HealthVault "Patient Connect" workflow.  This workflow is used to establish application authorization for a HealthVault user account.  Similar service-contracts are provided for Data Access and for the "Drop-Off and Pick-Up" information exchange workflow.

```C#
// Patient Connect Service-Interface
[ServiceContract]
public interface IHVConnect
{
    [OperationContract]
    ConnectResponse CreateConnection(ConnectRequest request);
    [OperationContract]
    ValidatedConnectionsResponse GetValidatedConnections(ValidatedConnectionsRequest request);
    [OperationContract]
    DeletePendingConnectionResponse DeletePendingConnection(DeletePendingConnectionRequest request);
    [OperationContract]
    RevokeApplicationConnectionResponse RevokeApplicationConnection(RevokeApplicationConnectionRequest request);
}

// Patient Connect Client Implementation
static void TestCreateConnection(string token, ref PatientRecord record)
{
    try
    {
        HVConnect.HVConnectClient client = new HVConnect.HVConnectClient();
        HVConnect.ConnectRequest request = new HVConnect.ConnectRequest();

         request.Token = token;
         request.LocalPersonName = record.PatientName;       
         request.LocalRecordId = record.PatientId;           
         request.SecretQuestion = record.SecretQuestion;
         request.SecretAnswer = record.SecretAnswer;

         HVConnect.ConnectResponse response = client.CreateConnection(request);

          if (response.Success)
          {
              record.ConnectCode = response.ConnectionCode;
              record.PickUpURL = response.PickupUrl;
              Console.WriteLine("Connection Code = {0}\n", response.ConnectionCode);
              Console.WriteLine("PickupUrl = {0}\n", response.PickupUrl);
           }
           else
              Console.WriteLine("Error = {0}\n", response.Message);
     }
    catch (Exception ex)
    {
         Console.WriteLine("Exception : CreateConnection : {0}", ex.Message);
         return;
     }
}
```

## Source Files
See HVProxyTest.cs for client-side usage scenarios for each service interface. 