using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;
using HVAppCode;
using Microsoft.Health;

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
        DateTime lastUpdateDate;
        Guid personId;
        Guid recordId;

        public RecordUpdateInfo(DateTime dt, Guid pid, Guid rid)
        {
            lastUpdateDate = dt;
            personId = pid;
            recordId = rid;
        }
        [DataMember]
        public DateTime LastUpdateDate
        {
            get { return lastUpdateDate; }
            set { lastUpdateDate = value; }
        }
        [DataMember]
        public Guid PersonId
        {
            get { return personId; }
            set { personId = value; }
        }
        [DataMember]
        public Guid RecordId
        {
            get { return recordId; }
            set { recordId = value; }
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
