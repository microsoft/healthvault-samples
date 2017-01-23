using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;
using HVAppCode;
using Microsoft.Health.PatientConnect;
using System.Collections.ObjectModel;

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

