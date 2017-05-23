// Copyright (c) Microsoft Corporation.  All rights reserved.
// MIT License
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ""Software""), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

using System;
using System.Collections.Generic;
using System.Xml;
using System.Xml.XPath;
using HVAppCode;
using Microsoft.Health;

namespace HealthVaultProxy
{
    public class HVDataAccess : IHVDataAccess
    {
        public GetUpdatedRecordsResponse GetUpdatedRecords(GetUpdatedRecordsRequest request)
        {
            GetUpdatedRecordsResponse response = new GetUpdatedRecordsResponse();
            try
            {
                if (string.IsNullOrEmpty(request.Token))
                    throw (new System.ArgumentNullException("Token", AppSettings.NullInputEncountered));

                HealthVaultConnection hv = new HealthVaultConnection(request.Token);

                IList<HealthRecordUpdateInfo> records = hv.GetUpdatedRecordsSince(request.SinceDate);
                response.UpdatedRecords = new List<RecordUpdateInfo>();
                foreach (HealthRecordUpdateInfo r in records)
                {
                    response.UpdatedRecords.Add(new RecordUpdateInfo(r.LastUpdateDate, r.PersonId, r.RecordId));
                }
            }
            catch (Microsoft.Health.HealthServiceException hex)
            {
                response.Success = false;
                response.Message = hex.ToString();
            }
            catch (Exception ex)
            {
                response.Success = false;
                response.Message = ex.Message;
                response.Stack = ex.StackTrace;
            }
            return (response);
        }

        public GetThingsResponse GetThings(GetThingsRequest request)
        {
            GetThingsResponse response = new GetThingsResponse();
            try
            {
                if (string.IsNullOrEmpty(request.Token))
                    throw (new System.ArgumentNullException("Token", AppSettings.NullInputEncountered));

                if (request.PersonId.Equals(Guid.Empty))
                    throw (new System.ArgumentNullException("PersonId", AppSettings.NullInputEncountered));

                foreach (Guid typeId in request.TypeIds)
                {
                    if (typeId.Equals(Guid.Empty))
                        throw (new System.ArgumentNullException("TypeId", AppSettings.NullInputEncountered));
                }

                HealthVaultConnection hv = new HealthVaultConnection(request.Token, request.PersonId);

                response.Things = hv.GetThings(request.RecordId, request.TypeIds, request.SinceDate);
            }
            catch (Microsoft.Health.HealthServiceException hex)
            {
                response.Success = false;
                response.Message = hex.ToString();
            }
            catch (Exception ex)
            {
                response.Success = false;
                response.Message = ex.Message;
                response.Stack = ex.StackTrace;
            }
            return response;
        }

        public PutThingsResponse PutThings(PutThingsRequest request)
        {
            PutThingsResponse response = new PutThingsResponse();
            try
            {
                if (string.IsNullOrEmpty(request.Token))
                    throw (new System.ArgumentNullException("Token", AppSettings.NullInputEncountered));

                if (request.PersonId.Equals(Guid.Empty))
                    throw (new System.ArgumentNullException("PersonId", AppSettings.NullInputEncountered));

                if (request.RecordId.Equals(Guid.Empty))
                    throw (new System.ArgumentNullException("RecordId", AppSettings.NullInputEncountered));

                response.CountReceived = 0;
                response.IndexOnError = 0;
                response.CountSucceeded = 0;
                foreach (string item in request.XmlInputs)
                {
                    response.CountReceived += 1;
                    response.IndexOnError = response.CountReceived - 1;

                    XmlDocument doc = new XmlDocument();
                    doc.LoadXml(item);
                    XPathNavigator nav = doc.CreateNavigator();

                    XPathNavigator navTypeId = nav.SelectSingleNode("//type-id");
                    Guid typeId = new Guid(navTypeId.InnerXml);

                    XPathNavigator navData = nav.SelectSingleNode("//data-xml");
                    navData.MoveToFirstChild();

                    HealthVaultConnection hv = new HealthVaultConnection(request.Token, request.PersonId);
                    HealthRecordItem newItem = new HealthRecordItem(typeId, navData);
                    hv.PutThings(request.RecordId, ref newItem);

                    response.CountSucceeded += 1;
                }
            }
            catch (Microsoft.Health.HealthServiceException hex)
            {
                response.Success = false;
                response.Message = hex.ToString();
            }
            catch (Exception ex)
            {
                response.Success = false;
                response.Message = ex.Message;
                response.Stack = ex.StackTrace;
            }
            return response;
        }

        public PutThingResponse PutThing(PutThingRequest request)
        {
            PutThingResponse response = new PutThingResponse();
            try
            {
                if (string.IsNullOrEmpty(request.Token))
                    throw (new System.ArgumentNullException("Token", AppSettings.NullInputEncountered));

                if (request.PersonId.Equals(Guid.Empty))
                    throw (new System.ArgumentNullException("PersonId", AppSettings.NullInputEncountered));

                if (request.RecordId.Equals(Guid.Empty))
                    throw (new System.ArgumentNullException("RecordId", AppSettings.NullInputEncountered));

                if (string.IsNullOrEmpty(request.TypeName))
                    throw (new System.ArgumentNullException("TypeName", AppSettings.NullInputEncountered));

                if (request.TypeId.Equals(Guid.Empty))
                    throw (new System.ArgumentNullException("TypeId", AppSettings.NullInputEncountered));

                if (string.IsNullOrEmpty(request.XmlItem))
                    throw (new System.ArgumentNullException("XmlItem", AppSettings.NullInputEncountered));

                XmlDocument doc = new XmlDocument();
                doc.LoadXml(request.XmlItem);
                XPathNavigator nav = doc.CreateNavigator();
                XPathNavigator navData = nav.SelectSingleNode("//" + request.TypeName);

                if (navData.LocalName.CompareTo(request.TypeName) != 0)
                {
                    throw (new System.ArgumentException("Specified TypeName not found within input string argument.", "XmlItem"));
                }

                HealthVaultConnection hv = new HealthVaultConnection(request.Token, request.PersonId);
                HealthRecordItem newItem = new HealthRecordItem(request.TypeId, navData);
                hv.PutThings(request.RecordId, ref newItem);
            }
            catch (Microsoft.Health.HealthServiceException hex)
            {
                response.Success = false;
                response.Message = hex.ToString();
            }
            catch (Exception ex)
            {
                response.Success = false;
                response.Message = ex.Message;
                response.Stack = ex.StackTrace;
            }
            return response;
        }
    }
}
