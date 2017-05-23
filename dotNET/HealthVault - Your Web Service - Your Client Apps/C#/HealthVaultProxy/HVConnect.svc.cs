// Copyright (c) Microsoft Corporation.  All rights reserved.
// MIT License
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ""Software""), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

using System;
using HVAppCode;
using System.Collections.ObjectModel;
using Microsoft.Health.PatientConnect;

namespace HealthVaultProxy
{
    public class HVConnect : IHVConnect
    {
        public ConnectResponse CreateConnection(ConnectRequest request)
        {
            ConnectResponse response = new ConnectResponse();
            try
            {
                if (string.IsNullOrEmpty(request.Token))
                    throw (new System.ArgumentNullException("Token", AppSettings.NullInputEncountered));

                if (string.IsNullOrEmpty(request.LocalRecordId))
                    throw (new System.ArgumentNullException("LocalRecordId", AppSettings.NullInputEncountered));

                if (string.IsNullOrEmpty(request.LocalPersonName))
                    throw (new System.ArgumentNullException("LocalPersonName", AppSettings.NullInputEncountered));

                if (string.IsNullOrEmpty(request.SecretQuestion))
                    throw (new System.ArgumentNullException("SecretQuestion", AppSettings.NullInputEncountered));

                if (string.IsNullOrEmpty(request.SecretAnswer))
                    throw (new System.ArgumentNullException("SecretAnswer", AppSettings.NullInputEncountered));

                HealthVaultConnection hv = new HealthVaultConnection(request.Token);

                response.ConnectionCode = hv.CreateConnectionRequest(request.LocalRecordId, request.LocalPersonName, request.SecretQuestion, request.SecretAnswer);
                response.PickupUrl = AppSettings.PickupUrl();
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

        public ValidatedConnectionsResponse GetValidatedConnections(ValidatedConnectionsRequest request)
        {
            ValidatedConnectionsResponse response = new ValidatedConnectionsResponse();
            try
            {
                if (string.IsNullOrEmpty(request.Token))
                    throw (new System.ArgumentNullException("Token", AppSettings.NullInputEncountered));

                HealthVaultConnection hv = new HealthVaultConnection(request.Token);
                Collection<ValidatedPatientConnection> Connections = hv.GetValidatedConnectionsSince(request.SinceDate);

                response.Connections = new Collection<ValidatedConnection>();
                foreach (ValidatedPatientConnection hvconn in Connections)
                {
                    ValidatedConnection conn = new ValidatedConnection();
                    conn.ApplicationId = hvconn.ApplicationId;
                    conn.ApplicationPatientId = hvconn.ApplicationPatientId;
                    conn.ApplicationSpecificRecordId = hvconn.ApplicationSpecificRecordId;
                    conn.PersonId = hvconn.PersonId;
                    conn.RecordId = hvconn.RecordId;
                    response.Connections.Add(conn);
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

        public DeletePendingConnectionResponse DeletePendingConnection(DeletePendingConnectionRequest request)
        {
            DeletePendingConnectionResponse response = new DeletePendingConnectionResponse();
            try
            {
                if (string.IsNullOrEmpty(request.Token))
                    throw (new System.ArgumentNullException("Token", AppSettings.NullInputEncountered));

                if (string.IsNullOrEmpty(request.LocalRecordId))
                    throw (new System.ArgumentNullException("LocalRecordId", AppSettings.NullInputEncountered));

                HealthVaultConnection hv = new HealthVaultConnection(request.Token);
                hv.DeletePendingConnectionRequest(request.LocalRecordId);
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

        public RevokeApplicationConnectionResponse RevokeApplicationConnection(RevokeApplicationConnectionRequest request)
        {
            RevokeApplicationConnectionResponse response = new RevokeApplicationConnectionResponse();
            try
            {
                if (string.IsNullOrEmpty(request.Token))
                    throw (new System.ArgumentNullException("Token", AppSettings.NullInputEncountered));

                if (request.PersonId.Equals(Guid.Empty))
                    throw (new System.ArgumentNullException("PersonId", AppSettings.NullInputEncountered));

                HealthVaultConnection hv = new HealthVaultConnection(request.Token, request.PersonId);
                hv.RevokeApplicationConnection(request.RecordId);
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
