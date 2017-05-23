// Copyright (c) Microsoft Corporation.  All rights reserved.
// MIT License
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ""Software""), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

using System;
using System.Collections.Generic;
using System.Runtime.Serialization;
using System.ServiceModel;

namespace HealthVaultProxy
{
    [ServiceContract]
    public interface IHVDataAccess
    {
        [OperationContract]
        GetUpdatedRecordsResponse GetUpdatedRecords(GetUpdatedRecordsRequest request);

        [OperationContract]
        GetThingsResponse GetThings(GetThingsRequest request);

        [OperationContract]
        PutThingResponse PutThing(PutThingRequest request);            // put a single thing item by name

        [OperationContract]
        PutThingsResponse PutThings(PutThingsRequest request);         // put a list of thing items by type-id
    }

    [DataContract]
    public class GetUpdatedRecordsRequest
    {
        [DataMember]
        public string Token { get; set; }
        [DataMember]
        public DateTime SinceDate { get; set; }
    }

    [DataContract]
    public class RecordUpdateInfo
    {
        private DateTime _lastUpdateDate;
        private Guid _personId;
        private Guid _recordId;

        public RecordUpdateInfo(DateTime dt, Guid pid, Guid rid)
        {
            _lastUpdateDate = dt;
            _personId = pid;
            _recordId = rid;
        }

        [DataMember]
        public DateTime LastUpdateDate
        {
            get { return _lastUpdateDate; }
            set { _lastUpdateDate = value; }
        }
        [DataMember]
        public Guid PersonId
        {
            get { return _personId; }
            set { _personId = value; }
        }
        [DataMember]
        public Guid RecordId
        {
            get { return _recordId; }
            set { _recordId = value; }
        }
    }

    [DataContract]
    public class GetUpdatedRecordsResponse : HVProxyResponse
    {
        [DataMember]
        public IList<RecordUpdateInfo> UpdatedRecords;
    }

    [DataContract]
    public class GetThingsRequest
    {
        [DataMember]
        public string Token { get; set; }
        [DataMember]
        public Guid PersonId { get; set; }
        [DataMember]
        public Guid RecordId { get; set; }
        [DataMember]
        public Guid[] TypeIds { get; set; }
        [DataMember]
        public DateTime SinceDate { get; set; }
    }

    public class GetThingsResponse : HVProxyResponse
    {
        public GetThingsResponse()
            : base()
        {
            Things = new List<string>();
        }

        [DataMember]
        public List<string> Things;
    }

    [DataContract]
    public class PutThingsRequest
    {
        [DataMember]
        public string Token { get; set; }
        [DataMember]
        public Guid PersonId { get; set; }
        [DataMember]
        public Guid RecordId { get; set; }
        [DataMember]
        public string[] XmlInputs { get; set; }
    }

    [DataContract]
    public class PutThingsResponse : HVProxyResponse
    {
        [DataMember]
        public int CountReceived { get; set; }
        [DataMember]
        public int IndexOnError { get; set; }
        [DataMember]
        public int CountSucceeded { get; set; }
    }

    [DataContract]
    public class PutThingRequest
    {
        [DataMember]
        public string Token { get; set; }
        [DataMember]
        public Guid PersonId { get; set; }
        [DataMember]
        public Guid RecordId { get; set; }
        [DataMember]
        public string TypeName { get; set; }
        [DataMember]
        public Guid TypeId { get; set; }
        [DataMember]
        public string XmlItem { get; set; }
    }

    [DataContract]
    public class PutThingResponse : HVProxyResponse
    {
        // FUTURE : Add methods as needed.
    }
}
