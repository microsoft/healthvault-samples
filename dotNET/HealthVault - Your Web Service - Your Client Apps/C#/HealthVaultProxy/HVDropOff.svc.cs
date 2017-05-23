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

// see info here:  http://msdn.microsoft.com/en-us/library/ff803640.aspx

namespace HealthVaultProxy
{
    public class HVDropOff : IHVDropOff
    {
        public PreAllocatePackageIdResponse PreAllocatePackageId(string token)
        {
            PreAllocatePackageIdResponse response = new PreAllocatePackageIdResponse();
            try
            {
                if (string.IsNullOrEmpty(token))
                    throw (new System.ArgumentNullException("token", AppSettings.NullInputEncountered));

                HealthVaultConnection hv = new HealthVaultConnection(token);
                response.DopuPackageId = hv.AllocatePackageId();
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

        public DropOffResponse DropOffForPatient(DropOffRequest request)
        {
            return (DropOff(ref request, false));
        }

        public DropOffResponse DropOffForPackageId(DropOffRequest request)
        {
            // request.PackageId must not be null or empty in this case.
            return (DropOff(ref request, true));
        }

        private DropOffResponse DropOff(ref DropOffRequest request, bool isForPackageId)
        {
            DropOffResponse response = new DropOffResponse();
            try
            {
                if ((isForPackageId) && (string.IsNullOrEmpty(request.DopuPackageId)))
                    throw (new System.ArgumentNullException("DopuPackageId", AppSettings.NullInputEncountered));

                if (string.IsNullOrEmpty(request.LocalPatientId))
                    throw (new System.ArgumentNullException("LocalPatientId", AppSettings.NullInputEncountered));

                if (string.IsNullOrEmpty(request.Token))
                    throw (new System.ArgumentNullException("Token", AppSettings.NullInputEncountered));

                if (string.IsNullOrEmpty(request.FromName))
                    throw (new System.ArgumentNullException("FromName", AppSettings.NullInputEncountered));

                if (request.EmailTo.Count == 0)
                    throw (new System.ArgumentNullException("EmailTo", AppSettings.NullInputEncountered));

                foreach (string email in request.EmailTo)
                {
                    if (string.IsNullOrEmpty(email))
                        throw (new System.ArgumentNullException("EmailTo", AppSettings.NullInputEncountered));
                }

                if (string.IsNullOrEmpty(request.EmailFrom))
                    throw (new System.ArgumentNullException("EmailFrom", AppSettings.NullInputEncountered));

                if (string.IsNullOrEmpty(request.EmailSubject))
                    throw (new System.ArgumentNullException("EmailSubject", AppSettings.NullInputEncountered));

                if (string.IsNullOrEmpty(request.SecretQuestion))
                    throw (new System.ArgumentNullException("SecretQuestion", AppSettings.NullInputEncountered));

                if (string.IsNullOrEmpty(request.SecretAnswer))
                    throw (new System.ArgumentNullException("SecretAnswer", AppSettings.NullInputEncountered));

                if (request.Things.Count == 0)
                    throw (new System.ArgumentNullException("Things", AppSettings.NullInputEncountered));

                List<HealthRecordItem> newRecords = new List<HealthRecordItem>();

                foreach (string thing in request.Things)
                {
                    XmlDocument doc = new XmlDocument();
                    doc.LoadXml(thing);
                    XPathNavigator nav = doc.CreateNavigator();

                    XPathNavigator navTypeId = nav.SelectSingleNode("//type-id");
                    Guid typeId = new Guid(navTypeId.InnerXml);

                    XPathNavigator navData = nav.SelectSingleNode("//data-xml");
                    navData.MoveToFirstChild();

                    newRecords.Add(new HealthRecordItem(typeId, navData));
                }

                HealthVaultConnection hv = new HealthVaultConnection(request.Token);

                if (isForPackageId)
                    response.SecretCode = hv.DropOff(request.DopuPackageId,
                                                     request.FromName,
                                                     request.LocalPatientId,
                                                     request.SecretQuestion,
                                                     request.SecretAnswer,
                                                     ref newRecords);
                else
                    response.SecretCode = hv.DropOff(request.FromName,
                                                     request.LocalPatientId,
                                                     request.SecretQuestion,
                                                     request.SecretAnswer,
                                                     ref newRecords);

                // Compose the pickup URL using the Microsoft.Health.Web utilities...
                // e.g.  https://account.healthvault-ppe.com/patientwelcome.aspx?packageid=JKXF-JRMX-ZKZM-KGZM-RKKX
                // e.g. https://shellhostname/redirect.aspx?target=PICKUP&targetqs=packageid%3dJKYZ-QNMN-VHRX-ZGNR-GZNH

                response.PickupUrl = AppSettings.PickupUrl();
                response.PickupUrl += @"?packageid=";
                response.PickupUrl += response.SecretCode;

                string emailBody = AppSettings.DOPUemailTemplate.Replace("[PICKUP]", response.PickupUrl);
                emailBody = emailBody.Replace("[SECRET]", response.SecretCode);

                hv.SendInsecureMessageFromApplication(request.EmailTo, request.EmailFrom, request.EmailSubject, emailBody);
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

        public HVProxyResponse DeletePendingForPatient(string token, string localPatientId)
        {
            HVProxyResponse response = new HVProxyResponse();

            try
            {
                if (string.IsNullOrEmpty(token))
                    throw (new System.ArgumentNullException("Token", AppSettings.NullInputEncountered));

                if (string.IsNullOrEmpty(localPatientId))
                    throw (new System.ArgumentNullException("LocalPatientId", AppSettings.NullInputEncountered));

                HealthVaultConnection hv = new HealthVaultConnection(token);

                if (string.IsNullOrEmpty(localPatientId))
                    throw (new System.ArgumentNullException("LocalPatientId", AppSettings.NullInputEncountered));
                hv.DeletePendingDropForPatientId(localPatientId);
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

        public HVProxyResponse DeletePendingForPackageId(string token, string dopuPackageId)
        {
            HVProxyResponse response = new HVProxyResponse();

            try
            {
                if (string.IsNullOrEmpty(token))
                    throw (new System.ArgumentNullException("Token", AppSettings.NullInputEncountered));

                if (string.IsNullOrEmpty(dopuPackageId))
                    throw (new System.ArgumentNullException("LocalPatientId", AppSettings.NullInputEncountered));

                HealthVaultConnection hv = new HealthVaultConnection(token);

                if (string.IsNullOrEmpty(dopuPackageId))
                    throw (new System.ArgumentNullException("DopuPackageId", AppSettings.NullInputEncountered));

                hv.DeletePendingDropForPackageId(dopuPackageId);
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
