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
using Microsoft.Health;
using Microsoft.Health.PatientConnect;
using Microsoft.Health.Web;

namespace HVAppCode
{
    public class HealthVaultConnection
    {
        public HealthVaultConnection(string token) : this(token, Guid.Empty) { }

        public HealthVaultConnection(string token, Guid personId)
        {
            if (AppSettings.IsValidToken(token))
            {
                _connection = new OfflineWebApplicationConnection(HealthWebApplicationConfiguration.Current.ApplicationId,
                    HealthWebApplicationConfiguration.Current.HealthVaultMethodUrl,
                    personId);
                _connection.Authenticate();
            }
            else
                throw (new ArgumentException("Your application token is invalid.", "token"));
        }

        public string CreateConnectionRequest(string localRecordId, string localFriendlyName, string secretQuestion, string secretAnswer)
        {
            string connectionCode =
                PatientConnection.Create(_connection, localFriendlyName, secretQuestion, secretAnswer, null, localRecordId);

            return (connectionCode);
        }

        public Collection<ValidatedPatientConnection> GetValidatedConnectionsSince(DateTime lastCheckedUtc)
        {
            return (PatientConnection.GetValidatedConnections(_connection, lastCheckedUtc));
        }

        public void DeletePendingConnectionRequest(string localRecordId)
        {
            PatientConnection.DeletePending(_connection, localRecordId);
        }

        public IList<HealthRecordUpdateInfo> GetUpdatedRecordsSince(DateTime lastCheckedUtc)
        {
            return (_connection.GetUpdatedRecordInfoForApplication(lastCheckedUtc));
        }

        public void RevokeApplicationConnection(Guid recordId)
        {
            // connection must have been created in the context of a person
            HealthRecordAccessor record = new HealthRecordAccessor(_connection, recordId);
            record.RemoveApplicationAuthorization();
        }

        public List<string> GetThings(Guid recordId, Guid[] typeIds, DateTime updatedSinceUtc)
        {
            return (HealthVaultGetThings.GetThings(_connection, recordId, typeIds, updatedSinceUtc));
        }

        public void PutThings(Guid recordId, ref HealthRecordItem newItem)
        {
            HealthVaultPutThings.PutThings(_connection, recordId, ref newItem);
        }

        public string AllocatePackageId()
        {
            return (HealthVaultDOPU.AllocatePackageId(_connection));
        }

        public string DropOff(string fromName, string localPatientId, string secretQuestion, string secretAnswer, ref List<HealthRecordItem> newItems)
        {
            return (HealthVaultDOPU.DropOffToPatient(_connection,
                                                    fromName,
                                                    localPatientId,
                                                    secretQuestion,
                                                    secretAnswer,
                                                    ref newItems));
        }

        public string DropOff(string dopuPackageId, string fromName, string localPatientId, string secretQuestion, string secretAnswer, ref List<HealthRecordItem> newItems)
        {
            return (HealthVaultDOPU.DropOffToPackage(_connection,
                                                    dopuPackageId,
                                                    fromName,
                                                    localPatientId,
                                                    secretQuestion,
                                                    secretAnswer,
                                                    ref newItems));
        }

        public void DeletePendingDropForPackageId(string packageId)
        {
            HealthVaultDOPU.DeletePendingForPackageId(_connection, packageId);
        }

        public void DeletePendingDropForPatientId(string patientId)
        {
            HealthVaultDOPU.DeletePendingForPatientId(_connection, patientId);
        }

        public void SendInsecureMessageFromApplication(List<string> emailTo, string emailFrom, string emailSubject, string emailBody)
        {
            List<MailRecipient> recipients = new List<MailRecipient>();
            foreach (string email in emailTo)
                recipients.Add(new MailRecipient(email, email));

            _connection.SendInsecureMessageFromApplication(recipients, emailFrom, emailFrom, emailSubject, emailBody, string.Empty);
        }

        public OfflineWebApplicationConnection Connection { get { return (_connection); } }

        private OfflineWebApplicationConnection _connection;
    }
}
