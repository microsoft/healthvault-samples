using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;

namespace HealthVaultProxy
{
    [ServiceContract]
    public interface IHVDropOff
    {
        // NOTE:  Only a subset of HV API functionality represented here.   See http://msdn.microsoft.com/en-us/library/dd724590.aspx.
        [OperationContract]
        PreAllocatePackageIdResponse PreAllocatePackageId(string token);
        [OperationContract]
        DropOffResponse DropOffForPatient(DropOffRequest request);
        [OperationContract]
        DropOffResponse DropOffForPackageId(DropOffRequest request);
        [OperationContract]
        HVProxyResponse DeletePendingForPatient(string Token, string LocalPatientId);
        [OperationContract]
        HVProxyResponse DeletePendingForPackageId(string Token, string DopuPackageId);
    }

    [DataContract]
    public class PreAllocatePackageIdResponse : HVProxyResponse
    {
        [DataMember]
        public string DopuPackageId { get; set; }
    }

    [DataContract]
    public class DropOffRequest
    {
        public DropOffRequest()
        {
            Things = new List<string>();
            EmailTo = new List<string>();
        }        
        [DataMember]
        public string Token { get; set; }
        [DataMember]
        public string FromName { get; set; }
        [DataMember]
        public string LocalPatientId { get; set; }   
        [DataMember]
        public string DopuPackageId { get; set; }     // set either from previous call to PreAllocatePackageId or to string.Empty
        [DataMember]
        public List<string> EmailTo { get; set; }
        [DataMember]
        public string EmailFrom { get; set; }
        [DataMember]
        public string EmailSubject { get; set; }
        [DataMember]
        public string SecretQuestion { get; set; }
        [DataMember]
        public string SecretAnswer { get; set; }
        [DataMember]
        public List<string> Things;
    }

    [DataContract]
    public class DropOffResponse : HVProxyResponse
    {
        [DataMember]
        public string SecretCode { get; set; }
        [DataMember]
        public string PickupUrl { get; set; }
    }

}
