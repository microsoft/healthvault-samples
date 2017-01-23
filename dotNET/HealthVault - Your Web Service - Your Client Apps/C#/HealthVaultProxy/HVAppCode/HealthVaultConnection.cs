// Copyright (c) Microsoft Corporation.  All rights reserved. 
// MIT License
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ""Software""), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Security.Cryptography.X509Certificates;
using System.Linq;
using System.Web;
using Microsoft.Health;
using Microsoft.Health.PatientConnect;
using Microsoft.Health.Web;
using Microsoft.Health.Web.Authentication;  

namespace HVAppCode
{
    public class HealthVaultConnection
    {
        public HealthVaultConnection(string token) : this(token, Guid.Empty) { } 

        public HealthVaultConnection(string token, Guid personId)    
        {
            if (AppSettings.IsValidToken(token))
            {

                string certFilePath = System.Web.Hosting.HostingEnvironment.MapPath(@"~\App_Data\" + AppSettings.PfxFileName());
                X509Certificate2 cert = new X509Certificate2(certFilePath, String.Empty, X509KeyStorageFlags.MachineKeySet);
                WebApplicationCredential cred = new WebApplicationCredential(AppSettings.ApplicationId(), "x" /*hack*/, cert);
                cred.SubCredential = null; /* more hack */
                m_connection = new OfflineWebApplicationConnection(cred, AppSettings.ApplicationId(), AppSettings.PlatformUrl(), personId);
            }
            else
                throw (new ArgumentException("Your application token is invalid.", "token"));
        }

        public string CreateConnectionRequest(string localRecordId, string localFriendlyName, string secretQuestion, string secretAnswer)
        {
            string connectionCode =
                PatientConnection.Create(m_connection, localFriendlyName, secretQuestion, secretAnswer, null, localRecordId);

            return (connectionCode);
        }

        public Collection<ValidatedPatientConnection> GetValidatedConnectionsSince(DateTime lastCheckedUtc)
        {
            return (PatientConnection.GetValidatedConnections(m_connection, lastCheckedUtc));
        }

        public void DeletePendingConnectionRequest(string localRecordId)
        {
            PatientConnection.DeletePending(m_connection, localRecordId);
        }

        public IList<HealthRecordUpdateInfo> GetUpdatedRecordsSince(DateTime lastCheckedUtc)
        {
            return (m_connection.GetUpdatedRecordInfoForApplication(lastCheckedUtc));
        }

        public void RevokeApplicationConnection(Guid recordId)
        {
            // connection must have been created in the context of a person
            HealthRecordAccessor record = new HealthRecordAccessor(m_connection, recordId);
            record.RemoveApplicationAuthorization();
        }
        
        public List<string> GetThings(Guid recordId, Guid[] typeIds, DateTime updatedSinceUtc)
        {
            return (HealthVaultGetThings.GetThings(m_connection, recordId, typeIds, updatedSinceUtc));
        }

        public void PutThings(Guid recordId, ref HealthRecordItem newItem)    
        {
            HealthVaultPutThings.PutThings(m_connection, recordId, ref newItem);
        }

        public string AllocatePackageId()
        {
            return (HealthVaultDOPU.AllocatePackageId(m_connection));
        }

        public string DropOff(string fromName, string localPatientId, string secretQuestion, string secretAnswer, ref List<HealthRecordItem> newItems)
        {
            return (HealthVaultDOPU.DropOffToPatient(m_connection, 
                                                    fromName,  
                                                    localPatientId, 
                                                    secretQuestion, 
                                                    secretAnswer, 
                                                    ref newItems));
        }

        public string DropOff(string dopuPackageId, string fromName, string localPatientId, string secretQuestion, string secretAnswer, ref List<HealthRecordItem> newItems)
        {
            return (HealthVaultDOPU.DropOffToPackage(m_connection,
                                                    dopuPackageId,
                                                    fromName,
                                                    localPatientId,
                                                    secretQuestion,
                                                    secretAnswer,
                                                    ref newItems));
        }

        public void DeletePendingDropForPackageId(string packageId)
        {
            HealthVaultDOPU.DeletePendingForPackageId(m_connection, packageId);
        }

        public void DeletePendingDropForPatientId(string patientId)
        {
            HealthVaultDOPU.DeletePendingForPatientId(m_connection, patientId);
        }

        public void SendInsecureMessageFromApplication(List<string> emailTo, string emailFrom, string emailSubject, string emailBody)
        {
            List<MailRecipient> recipients = new List<MailRecipient>();
            foreach (string email in emailTo)
                recipients.Add(new MailRecipient(email, email));

            m_connection.SendInsecureMessageFromApplication(recipients, emailFrom, emailFrom, emailSubject, emailBody, string.Empty); 
        }

        public OfflineWebApplicationConnection Connection { get { return (m_connection); } }

        private OfflineWebApplicationConnection m_connection;
    }
}

