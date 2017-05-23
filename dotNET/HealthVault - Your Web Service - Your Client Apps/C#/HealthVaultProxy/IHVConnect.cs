// Copyright (c) Microsoft Corporation.  All rights reserved.
// MIT License
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ""Software""), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

using System;
using System.Collections.ObjectModel;
using System.Runtime.Serialization;
using System.ServiceModel;

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
        private bool _success = true;
        private string _message = string.Empty;
        private string _stack = string.Empty;

        [DataMember]
        public bool Success
        {
            get { return _success; }
            set { _success = value; }
        }

        [DataMember]
        public string Message
        {
            get { return _message; }
            set { _message = value; }
        }

        [DataMember]
        public string Stack
        {
            get { return _stack; }
            set { _stack = value; }
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
