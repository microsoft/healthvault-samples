// Copyright (c) Microsoft Corporation.  All rights reserved.
// MIT License
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ""Software""), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

using System;
using System.Collections.Generic;
using System.Linq;
using System.Xml.Linq;
using CommandLine.Utility;

// YOU MAY NEED TO MODIFY App.Config FILE AS INDICATED
//<bindings>
//    <basicHttpBinding>
//        <binding name="BasicHttpBinding_IHVConnect" />
//        <binding name="BasicHttpBinding_IHVDataAccess" maxReceivedMessageSize="2147483647" />    <<< if receiving lots of data then extend your buffer-size
//        <binding name="BasicHttpBinding_IHVDropOff" />
//    </basicHttpBinding>
//</bindings>

namespace HealthVaultProxyTest
{
    internal class HVProxyTest
    {
        // Use optional command line arguments to invoke specific API tests.
        private const string myUsage = "\n\tUsage:\t[-deserialize] [-createconnection] [-getconnections] [-getthings] [-putthings] \n" +
                               "[-getupdatedrecords] [-deleteconnection] [-revokeapplication] [-DOPU] [-serialize] \n";

        private const string myHVApplicationToken = "A245FDA7-8D3B-4ACA-8A73-A4A2AC8001D9";     // must be listed in HealthVaultProxy -> HealthVaultAppSetting.cs

        public Guid[] myTypeIds = null;

        public HVProxyTest()   // constructor
        {
            myTypeIds = new Guid[]{  (new Guid("3d34d87e-7fc1-4153-800f-f56592cb0d17")),   // weight measurement                //
                                     (new Guid("415c95e0-0533-4d9c-ac73-91dc5031186c")),   // care plan
                                     (new Guid("ca3c57f4-f4c1-4e15-be67-0a3caf5414ed")),   // blood pressure measurement        //
                                     (new Guid("879e7c04-4e8a-4707-9ad3-b054df467ce4")),   // blood glucose measurement         //
                                     (new Guid("227f55fb-1001-4d4e-9f6a-8d893e07b451")),   // HbA1C                             //
                                     (new Guid("25c94a9f-9d3d-4576-96dc-6791178a8143")),   // emergency or provider contact
                                     (new Guid("40750a6a-89b2-455c-bd8d-b420a4cb500b")),   // height measurement                //
                                     (new Guid("796c186f-b874-471c-8468-3eeff73bf66e")),   // cholesterol measurement           //
                                     (new Guid("7ea7a1f9-880b-4bd4-b593-f5660f20eda8")),   // condition                         //
                                     (new Guid("85a21ddb-db20-4c65-8d30-33c899ccf612")),   // exercise                          //
                                     (new Guid("089646a6-7e25-4495-ad15-3e28d4c1a71d")),   // dietary intake
                                     (new Guid("30cafccc-047d-4288-94ef-643571f7919d")) };  // medication
        }

        private static void Main(string[] args)
        {
            HVProxyTest myHVProxyTest = new HVProxyTest();
            LocalPatientRecords myLocalPatientRecords = new LocalPatientRecords();
            string filePath = null;

            try
            {
                if (args.Count() == 0)
                {
                    Console.WriteLine("{0}", myUsage);
                    return;
                }

                Arguments CommandLine = new Arguments(args);

                if (CommandLine["deserialize"] != null)   // ****  DE-SERIALIZE LOCAL PATIENT RECORDS FROM FILE
                {
                    Console.WriteLine("\nImport patient records.  File name?  ");
                    filePath = Console.ReadLine();
                    myLocalPatientRecords = PatientRecordsSerializer.ReadFile(filePath);
                    foreach (PatientRecord pr in myLocalPatientRecords.PatientRecords)
                    {
                        Console.WriteLine("PatientId={0}\tLocalRecordId={1}\tPersonId={2}\tRecordId={3}", pr.PatientId, pr.ApplicationRecordId, pr.PersonId, pr.RecordId);
                    }
                }

                if (CommandLine["createconnection"] != null)  // **** TEST CREATE CONNECTION
                {
                    Console.WriteLine("\nTest CreateConnectionRequest API\n");
                    Console.WriteLine("Local patient name?  ");
                    string patientName = Console.ReadLine();
                    Console.WriteLine("Local patient identifier?  ");
                    string patientId = Console.ReadLine();
                    Console.WriteLine("Local patient eMail?  ");
                    string patientEmail = Console.ReadLine();
                    Console.WriteLine("Secret question?  ");
                    string secretQuestion = Console.ReadLine();
                    Console.WriteLine("Secret answer?  ");
                    string secretAnswer = Console.ReadLine();

                    //
                    PatientRecord patientRecord = new PatientRecord(patientId, patientName, patientEmail, secretQuestion, secretAnswer, null, null, null, null, null, "requested");
                    TestCreateConnection(myHVApplicationToken, ref patientRecord);
                    myLocalPatientRecords.PatientRecords.Add(patientRecord);

                    //
                    Console.WriteLine("Go validate the connection request using the provided URL and key, then return to this session.  \nPress any key to continue; 'q' to quit...\n");
                    if (Console.ReadKey().KeyChar == 'q')
                        return;
                }

                if (CommandLine["getconnections"] != null)   // **** TEST GET VALIDATED CONNECTIONS
                {
                    Console.WriteLine("\nTest GetValidatedConnections API\n");

                    //
                    TestGetValidatedConnections(myHVApplicationToken, ref myLocalPatientRecords);

                    //
                    Console.WriteLine("\nUse the connections info listed above for subsequent API tests. \nPress any key to continue; 'q' to quit...\n");
                    if (Console.ReadKey().KeyChar == 'q')
                        return;
                }

                if (CommandLine["getthings"] != null)   // **** TEST GET-THINGS
                {
                    Console.WriteLine("\nTest GetThings API\n");
                    Console.WriteLine("HV PersonId?  ");
                    string personId = Console.ReadLine();
                    Console.WriteLine("HV RecordId?  ");
                    string recordId = Console.ReadLine();

                    //
                    TestGetThings(myHVApplicationToken, personId, recordId, ref myHVProxyTest.myTypeIds);

                    //
                    Console.WriteLine("\nPress any key to continue; 'q' to quit...\n");
                    if (Console.ReadKey().KeyChar == 'q')
                        return;
                }

                if (CommandLine["putthing"] != null)    // **** TEST PUT-THING
                {
                    Console.WriteLine("\nTest PutThing API\n");
                    Console.WriteLine("HV PersonId?  ");
                    string personId = Console.ReadLine();
                    Console.WriteLine("HV RecordId?  ");
                    string recordId = Console.ReadLine();

                    //
                    TestPutThing(myHVApplicationToken, personId, recordId);

                    //
                    Console.WriteLine("\nPress any key to continue; 'q' to quit...\n");
                    if (Console.ReadKey().KeyChar == 'q')
                        return;
                }

                if (CommandLine["putthings"] != null)    // **** TEST PUT-THINGS
                {
                    Console.WriteLine("\nTest PutThings API\n");
                    Console.WriteLine("HV PersonId?  ");
                    string personId = Console.ReadLine();
                    Console.WriteLine("HV RecordId?  ");
                    string recordId = Console.ReadLine();

                    //
                    TestPutThings(myHVApplicationToken, personId, recordId);

                    //
                    Console.WriteLine("\nPress any key to continue; 'q' to quit...\n");
                    if (Console.ReadKey().KeyChar == 'q')
                        return;
                }

                if (CommandLine["getupdatedrecords"] != null)   // **** TEST GET UPDATED RECORDS
                {
                    Console.WriteLine("\nTest GetUpdatedRecords API\n");

                    //
                    TestGetUpdatedRecords(myHVApplicationToken);

                    //
                    Console.WriteLine("\nPress any key to continue; 'q' to quit...\n");
                    if (Console.ReadKey().KeyChar == 'q')
                        return;
                }

                if (CommandLine["deleteconnection"] != null)   // **** TEST DELETE PENDING CONNECTION
                {
                    Console.WriteLine("\nTest DeletePendingConnection API\n");
                    Console.WriteLine("Local patient identifier?  ");
                    string patientId = Console.ReadLine();

                    //
                    TestDeletePendingConnection(myHVApplicationToken, patientId);

                    //
                    Console.WriteLine("\nPress any key to continue; 'q' to quit...\n");
                    if (Console.ReadKey().KeyChar == 'q')
                        return;
                }

                if (CommandLine["revokeapplication"] != null)   // **** TEST REVOKE APPLICATION CONNECTION
                {
                    Console.WriteLine("\nTest RevokeApplicationConnection API\n");
                    Console.WriteLine("HV PersonId?  ");
                    string personId = Console.ReadLine();
                    Console.WriteLine("HV RecordId?  ");
                    string recordId = Console.ReadLine();

                    //
                    TestRevokeApplicationConnection(myHVApplicationToken, personId, recordId);

                    //
                    Console.WriteLine("\nPress any key to continue; 'q' to quit...\n");
                    if (Console.ReadKey().KeyChar == 'q')
                        return;
                }

                if (CommandLine["DOPU"] != null)   // **** TEST THE DROP-OFF PICK-UP API
                {
                    Console.WriteLine("\nTest Drop-Off and Pick-Up API\n");
                    Console.WriteLine("Local patient identifier?  ");
                    string patientId = Console.ReadLine();
                    Console.WriteLine("Local patient eMail?  ");
                    string patientEmail = Console.ReadLine();
                    Console.WriteLine("Secret question?  ");
                    string secretQuestion = Console.ReadLine();
                    Console.WriteLine("Secret answer?  ");
                    string secretAnswer = Console.ReadLine();

                    //
                    TestDropOffPickUp(myHVApplicationToken, patientId, patientEmail, secretQuestion, secretAnswer);

                    //
                    Console.WriteLine("\nPress any key to continue; 'q' to quit...\n");
                    if (Console.ReadKey().KeyChar == 'q')
                        return;
                }

                if (CommandLine["serialize"] != null)   // **** Serialize local patient records to file
                {
                    Console.WriteLine("\nExport patient records.  File name?  ");
                    filePath = Console.ReadLine();
                    PatientRecordsSerializer.WriteFile(filePath, myLocalPatientRecords);
                }

                // TO-DO : ADD OTHER API TESTS HERE.
            }
            catch (Exception ex)
            {
                Console.WriteLine("\nException : {0}\n{1}\n{2}", ex.Message, ex.InnerException.Message, ex.InnerException.StackTrace);
            }

            Console.WriteLine("\nPress any key to exit...\n");
            Console.ReadKey();
            return;
        }  // Main

        private static void TestCreateConnection(string token, ref PatientRecord record)
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

        private static void TestGetValidatedConnections(string token, ref LocalPatientRecords localPatientRecords)
        {
            try
            {
                HVConnect.HVConnectClient client = new HVConnect.HVConnectClient();
                HVConnect.ValidatedConnectionsRequest request = new HVConnect.ValidatedConnectionsRequest();

                request.Token = token;
                request.SinceDate = DateTime.Parse("1/1/1900");

                HVConnect.ValidatedConnectionsResponse response = client.GetValidatedConnections(request);

                if (response.Success)
                {
                    Console.WriteLine("\nValidated HealthVault Account Connections:\n");
                    foreach (HVConnect.ValidatedConnection vc in response.Connections)
                    {
                        if (localPatientRecords.ValidateRecord(vc) == false)
                        {
                            // This record is NOT known to us locally, add the connection to our list.
                            Console.WriteLine("\t**ORPHAN-RECORD: ApplicationID={0}\n\tPatientID={1}\n\tApplicationRecordID={2}\n\tPersonID={3}\n\tRecordID={4}\n",
                            vc.ApplicationId.ToString(),
                            vc.ApplicationPatientId,
                            vc.ApplicationSpecificRecordId,
                            vc.PersonId.ToString(),
                            vc.RecordId.ToString());

                            // Add the orphaned record to our list of records.
                            PatientRecord patientRecord = new PatientRecord(vc.ApplicationPatientId, "ORPHAN", "UNKOWN", "UNKNOWN", "UNKNOWN", "UNKOWN", "UNKNOWN", vc.PersonId.ToString(), vc.RecordId.ToString(), vc.ApplicationSpecificRecordId, "validated");
                            localPatientRecords.PatientRecords.Add(patientRecord);
                        }
                        else
                        {
                            // This record is known to us locally, no action needed.
                            Console.WriteLine("\tApplicationID={0}\n\tPatientID={1}\n\tApplicationRecordID={2}\n\tPersonID={3}\n\tRecordID={4}\n",
                                vc.ApplicationId.ToString(),
                                vc.ApplicationPatientId,
                                vc.ApplicationSpecificRecordId,
                                vc.PersonId.ToString(),
                                vc.RecordId.ToString());
                        }
                    }
                }
                else
                    Console.WriteLine("Error = {0}\n", response.Message);
            }
            catch (Exception ex)
            {
                Console.WriteLine("Exception : GetValidatedConnections : {0}", ex.Message);
                return;
            }
        }

        private static void TestGetThings(string token, string personId, string recordId, ref Guid[] typeIds)
        {
            try
            {
                HVDataAccess.HVDataAccessClient client = new HVDataAccess.HVDataAccessClient();
                HVDataAccess.GetThingsRequest request = new HVDataAccess.GetThingsRequest();

                request.Token = token;
                request.PersonId = new Guid(personId);
                request.RecordId = new Guid(recordId);
                request.TypeIds = typeIds;
                request.SinceDate = DateTime.Parse("1/1/2008");

                HVDataAccess.GetThingsResponse response = client.GetThings(request);
                if (response.Success)
                {
                    Console.WriteLine("\nGetThings Response:\n");
                    foreach (string item in response.Things)
                    {
                        // Example : use LINQ to parse the xml record
                        XElement thing = XElement.Parse(item);
                        Console.WriteLine(thing);

                        // Example : use SimpleThings classes to parse the xml into specific object types, Weight in this example.
                        Guid typeId = new Guid(thing.Element("type-id").Value);
                        if (typeId.Equals(typeIds[0]))                                // Weight type-id is expected at myTypeIds[0] in this test-app
                        {
                            SimpleWeight sw = new SimpleWeight();
                            sw.Initialize(item);
                            Console.WriteLine("SimpleWeight : {0}", sw.Display);
                        }
                    }
                }
                else
                    Console.WriteLine("Error = {0}\n", response.Message);
            }
            catch (Exception ex)
            {
                Console.WriteLine("Exception : TestGetThings : {0}", ex.Message);
                return;
            }
        }

        private static void TestPutThing(string token, string personId, string recordId)
        {
            try
            {
                HVDataAccess.HVDataAccessClient client = new HVDataAccess.HVDataAccessClient();
                HVDataAccess.PutThingRequest request = new HVDataAccess.PutThingRequest();

                request.Token = token;
                request.PersonId = new Guid(personId);
                request.RecordId = new Guid(recordId);
                request.TypeName = "care-plan";
                request.TypeId = new Guid("415c95e0-0533-4d9c-ac73-91dc5031186c");
                request.XmlItem = myCarePlan;

                HVDataAccess.PutThingResponse response = client.PutThing(request);

                if (response.Success == false)
                {
                    Console.WriteLine("Error = {0}\n", response.Message);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Exception : TestPutThing : {0}\n{1}", ex.Message, ex.StackTrace);
                return;
            }
        }

        private static void TestPutThings(string token, string personId, string recordId)
        {
            try
            {
                HVDataAccess.HVDataAccessClient client = new HVDataAccess.HVDataAccessClient();
                HVDataAccess.PutThingsRequest request = new HVDataAccess.PutThingsRequest();

                request.Token = token;
                request.PersonId = new Guid(personId);
                request.RecordId = new Guid(recordId);

                List<string> items = new List<string>();

                // Add a weight item entry just for testing.
                // See the Health types schema browser at http://developer.healthvault.com for more types.
                //
                items.Add(@"<thing>
                            <type-id>3d34d87e-7fc1-4153-800f-f56592cb0d17</type-id>
                            <data-xml>
                            <weight>
                                <when>
                                    <date>
                                        <y>2012</y>
                                        <m>4</m>
                                        <d>14</d>
                                    </date>
                                    <time>
                                        <h>1</h>
                                        <m>0</m>
                                        <s>0</s>
                                        <f>0</f>
                                    </time>
                                </when>
                                <value>
                                    <kg>60</kg>
                                    <display units='lb'>132</display>
                                </value>
                            </weight>
                            </data-xml>
                        </thing>");

                request.XmlInputs = items.ToArray<string>();

                HVDataAccess.PutThingsResponse response = client.PutThings(request);

                if (response.Success)
                {
                    Console.WriteLine("PutThings : Received={0}\tSucceeded={1}", response.CountReceived, response.CountSucceeded);
                }
                else
                {
                    Console.WriteLine("PutThings : Recevied={0}\tSucceeded={1}\tIndexOnError={2}\t\nError = {0}\n", response.CountReceived, response.CountSucceeded, response.IndexOnError, response.Message);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Exception : TestPutThings : {0}\n{1}", ex.Message, ex.StackTrace);
                return;
            }
        }

        private static void TestGetUpdatedRecords(string token)
        {
            try
            {
                HVDataAccess.HVDataAccessClient client = new HVDataAccess.HVDataAccessClient();
                HVDataAccess.GetUpdatedRecordsRequest request = new HVDataAccess.GetUpdatedRecordsRequest();

                request.Token = token;
                request.SinceDate = DateTime.Parse("4/1/2012");

                HVDataAccess.GetUpdatedRecordsResponse response = client.GetUpdatedRecords(request);

                if (response.Success)
                {
                    Console.WriteLine("\nGetUpdatedRecords Response:\n");
                    foreach (HVDataAccess.RecordUpdateInfo rui in response.UpdatedRecords)
                    {
                        Console.WriteLine("{0}\t{1}\t{2}\n", rui.LastUpdateDate.ToShortDateString(), rui.PersonId.ToString(), rui.RecordId.ToString());
                    }
                }
                else
                    Console.WriteLine("Error = {0}\n", response.Message);
            }
            catch (Exception ex)
            {
                Console.WriteLine("Exception : GetUpdatedRecords : {0}", ex.Message);
                return;
            }
        }

        private static void TestDeletePendingConnection(string token, string localRecordId)
        {
            try
            {
                HVConnect.HVConnectClient client = new HVConnect.HVConnectClient();
                HVConnect.DeletePendingConnectionRequest request = new HVConnect.DeletePendingConnectionRequest();

                request.Token = token;
                request.LocalRecordId = localRecordId;       // an identifier within local database

                HVConnect.DeletePendingConnectionResponse response = client.DeletePendingConnection(request);
                if (response.Success == false)
                    Console.WriteLine("\nError = {0}\n", response.Message);
            }
            catch (Exception ex)
            {
                Console.WriteLine("Exception : DeletePendingConnection : {0}", ex.Message);
                return;
            }
        }

        private static void TestRevokeApplicationConnection(string token, string personId, string recordId)
        {
            try
            {
                HVConnect.HVConnectClient client = new HVConnect.HVConnectClient();
                HVConnect.RevokeApplicationConnectionRequest request = new HVConnect.RevokeApplicationConnectionRequest();

                request.Token = token;
                request.PersonId = new Guid(personId);
                request.RecordId = new Guid(recordId);

                HVConnect.RevokeApplicationConnectionResponse response = client.RevokeApplicationConnection(request);

                if (response.Success == false)
                    Console.WriteLine("Error = {0}\n", response.Message);
            }
            catch (Exception ex)
            {
                Console.WriteLine("Exception : RevokeApplicationConnection : {0}", ex.Message);
                return;
            }
        }

        private static void TestDropOffPickUp(string token, string localPatientId, string emailTo, string secretQuestion, string secretAnswer)
        {
            try
            {
                HVDropOff.HVDropOffClient client = new HVDropOff.HVDropOffClient();
                HVDropOff.DropOffRequest request = new HVDropOff.DropOffRequest();

                request.Token = token;
                request.FromName = "HVProxyTest App";

                request.LocalPatientId = localPatientId;
                request.DopuPackageId = string.Empty;

                request.EmailFrom = "MomPennington";    // The @domain.com suffix will be appending by HV platform.  See HV Application Configuration Center.

                List<string> toList = new List<string>();
                toList.Add(emailTo);
                request.EmailTo = toList.ToArray<string>();

                request.EmailSubject = "Test HealthVault DropOff and Pickup";

                request.SecretQuestion = secretQuestion;
                request.SecretAnswer = secretAnswer;

                string thingWeight =
                    @"<thing>
                        <type-id>3d34d87e-7fc1-4153-800f-f56592cb0d17</type-id>
                        <data-xml>
                        <weight>
                            <when>
                                <date>
                                    <y>2013</y>
                                    <m>4</m>
                                    <d>14</d>
                                </date>
                                <time>
                                    <h>1</h>
                                    <m>0</m>
                                    <s>1</s>
                                    <f>0</f>
                                </time>
                            </when>
                            <value>
                                <kg>64</kg>
                                <display units='lb'>134</display>
                            </value>
                        </weight>
                        </data-xml>
                    </thing>";

                List<string> things = new List<string>();
                things.Add(thingWeight);

                request.Things = things.ToArray<string>();

                HVDropOff.DropOffResponse response = client.DropOffForPatient(request);

                if (response.Success)
                    Console.WriteLine("\nDropOff Secret Key = {0}\n", response.SecretCode);
                else
                    Console.WriteLine("Error = {0}\n", response.Message);
            }
            catch (Exception ex)
            {
                Console.WriteLine("Exception : TestDropOffPickUp : {0}\n{1}", ex.Message, ex.StackTrace);
                return;
            }
        }

        private const string myCarePlan = @"<?xml version='1.0'?>
<care-plan xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema'>
  <name>Diabetes Management</name>
  <start-date>
    <structured>
      <date>
        <y>2013</y>
        <m>4</m>
        <d>1</d>
      </date>
      <time>
        <h>0</h>
        <m>0</m>
      </time>
    </structured>
  </start-date>
  <status>
    <text>Active</text>
  </status>
  <care-team>
    <person>
      <name>
        <full>Cruz Roudabush</full>
        <first>Cruz</first>
        <last>Roudabush</last>
      </name>
      <contact>
        <address>
          <street>2202 S Central Ave</street>
          <city>Mechanicsburg</city>
          <state />
          <postcode>85004</postcode>
          <country />
        </address>
        <phone>
          <description>Home Phone</description>
          <number>602-252-4827</number>
        </phone>
        <email>
          <is-primary>true</is-primary>
          <address>cruz@roudabush.com</address>
        </email>
      </contact>
      <type>
        <text>Care Team Member</text>
      </type>
    </person>
    <person>
      <name>
        <full>Sidney Higa (sample)</full>
        <first>Sidney</first>
        <last>Higa (sample)</last>
      </name>
      <contact>
        <address>
          <street>7691 Benedict Ct.</street>
          <city>Issaquah</city>
          <state>WA</state>
          <postcode>57065</postcode>
          <country>U.S.</country>
        </address>
        <phone>
          <description>Business Phone</description>
          <number>555-0104</number>
        </phone>
        <email>
          <is-primary>true</is-primary>
          <address>someone_e@example.com</address>
        </email>
      </contact>
      <type>
        <text>Care Team Member</text>
      </type>
    </person>
    <person>
      <name>
        <full>Alicia Smith</full>
        <first>Alicia</first>
        <last>Smith</last>
      </name>
      <contact>
        <phone>
          <description>Home Phone</description>
         <number>717-258-6245</number>
        </phone>
      </contact>
      <type>
        <text>Care Team Member</text>
      </type>
    </person>
  </care-team>
  <care-plan-manager>
    <name>
      <full>Tom Gould</full>
      <title>
        <text>Dr</text>
      </title>
      <first>Tom</first>
      <last>Gould</last>
    </name>
    <contact>
      <address>
        <street>street1</street>
        <street>street2</street>
        <street>street3</street>
        <city>mechanicsburg</city>
        <state />
        <postcode />
        <country />
      </address>
      <phone>
        <description>Business Phone</description>
        <number>1-717-542-6584</number>
      </phone>
      <email>
        <is-primary>true</is-primary>
        <address>tgould@contoso.com</address>
      </email>
    </contact>
    <type>
      <text>Care Plan Manager</text>
    </type>
  </care-plan-manager>
  <tasks>
    <task>
      <name>
        <text>Measure blood glucose levels</text>
      </name>
      <start-date>
        <descriptive>4/1/2013</descriptive>
      </start-date>
      <end-date>
        <descriptive>5/10/2013</descriptive>
      </end-date>
      <sequence-number>2</sequence-number>
      <associated-type-info>
        <thing-type-version-id>879e7c04-4e8a-4707-9ad3-b054df467ce4</thing-type-version-id>
      </associated-type-info>
      <recurrence>
        <ical-recurrence>freq=20;count=Month</ical-recurrence>
      </recurrence>
    </task>
    <task>
      <name>
        <text>Get dilated eye exam</text>
      </name>
      <description>Get dilated eye exam every year</description>
      <start-date>
        <descriptive>4/1/2013</descriptive>
      </start-date>
      <end-date>
        <descriptive>4/24/2013</descriptive>
      </end-date>
      <recurrence>
        <ical-recurrence>freq=1;count=Year</ical-recurrence>
      </recurrence>
    </task>
    <task>
      <name>
        <text>Blood pressure checked at every diabetes visit</text>
      </name>
      <description>Have your blood pressure checked at every diabetes visit</description>
      <start-date>
        <descriptive>4/1/2013</descriptive>
      </start-date>
      <end-date>
        <descriptive>4/18/2013</descriptive>
      </end-date>
      <associated-type-info>
        <thing-type-version-id>ca3c57f4-f4c1-4e15-be67-0a3caf5414ed</thing-type-version-id>
      </associated-type-info>
    </task>
  </tasks>
  <goal-groups>
    <goal-group>
      <name>
        <text>Glucose levels</text>
      </name>
      <description>Keep your glucose levels under control.</description>
      <goals>
        <goal>
          <name>
            <text>Glucose</text>
          </name>
          <description>Glucose measurement should be above 70 mg/dl and below 240 mg/dl.</description>
          <start-date>
            <descriptive>4/1/2013</descriptive>
          </start-date>
          <associated-type-info>
            <thing-type-version-id>879e7c04-4e8a-4707-9ad3-b054df467ce4</thing-type-version-id>
          </associated-type-info>
        </goal>
        <goal>
          <name>
            <text>Hba1C</text>
          </name>
          <start-date>
            <descriptive>4/29/2013</descriptive>
          </start-date>
          <associated-type-info>
            <thing-type-version-id>227f55fb-1001-4d4e-9f6a-8d893e07b451</thing-type-version-id>
          </associated-type-info>
        </goal>
      </goals>
    </goal-group>
    <goal-group>
      <name>
        <text>Blood Presure</text>
      </name>
      <description>Keep your blood pressure under control.</description>
      <goals>
        <goal>
          <name>
            <text>Blood Pressure</text>
          </name>
          <description>Systolic should be below 130 mmHg. Diastolic should be less then 90 mmHg.</description>
          <start-date>
            <descriptive>4/1/2013</descriptive>
          </start-date>
          <associated-type-info>
            <thing-type-version-id>ca3c57f4-f4c1-4e15-be67-0a3caf5414ed</thing-type-version-id>
          </associated-type-info>
        </goal>
      </goals>
    </goal-group>
  </goal-groups>
</care-plan>";
    }  // class HVProxyTest
}  // namespace HealthVaultProxyTest
