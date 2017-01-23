using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;
using Microsoft.Health.PatientConnect;
using System.Collections.ObjectModel;

namespace HealthVaultProxy
{
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

    [DataContract]
    public class HVProxyResponse
    {
        bool success = true;
        string message = string.Empty;
        string stack = string.Empty;

        [DataMember]
        public bool Success
        {
            get { return success; }
            set { success = value; }
        }

        [DataMember]
        public string Message
        {
            get { return message; }
            set { message = value; }
        }

        [DataMember]
        public string Stack
        {
            get { return stack; }
            set { stack = value; }
        }
    }

    [DataContract]
    public class ConnectRequest
    {
        [DataMember]
        public string Token { get; set; }
        [DataMember]
        public string LocalPersonName { get; set; }
        [DataMember]
        public string LocalRecordId { get; set; }
        [DataMember]
        public string SecretQuestion { get; set; }
        [DataMember]
        public string SecretAnswer { get; set; }
    }

    [DataContract]
    public class ConnectResponse : HVProxyResponse
    {
        [DataMember]
        public string ConnectionCode { get; set; }
        [DataMember]
        public string PickupUrl { get; set; }
    }

    [DataContract]
    public class ValidatedConnectionsRequest
    {
        [DataMember]
        public string Token { get; set; }
        [DataMember]
        public DateTime SinceDate { get; set; }
    }

    [DataContract]
    public class ValidatedConnection
    {
        [DataMember]
        public Guid ApplicationId { get; set; }
        [DataMember]
        public string ApplicationPatientId { get; set; }
        [DataMember]
        public string ApplicationSpecificRecordId { get; set; }
        [DataMember]
        public Guid PersonId { get; set; }
        [DataMember]
        public Guid RecordId { get; set; }
    }

    [DataContract]
    public class ValidatedConnectionsResponse : HVProxyResponse
    {
        [DataMember]
        public Collection<ValidatedConnection> Connections;
    }

    [DataContract]
    public class DeletePendingConnectionRequest
    {
        [DataMember]
        public string Token { get; set; }
        [DataMember]
        public string LocalRecordId { get; set; }
    }

    [DataContract]
    public class DeletePendingConnectionResponse : HVProxyResponse
    {
        // FUTURE : Add methods as needed.
    }

    [DataContract]
    public class RevokeApplicationConnectionRequest
    {
        [DataMember]
        public string Token { get; set; }
        [DataMember]
        public Guid PersonId { get; set; }
        [DataMember]
        public Guid RecordId { get; set; }
    }

    [DataContract]
    public class RevokeApplicationConnectionResponse : HVProxyResponse
    {
        // FUTURE : Add methods as needed.
    }

}   // namespace HealthVaultProxy
