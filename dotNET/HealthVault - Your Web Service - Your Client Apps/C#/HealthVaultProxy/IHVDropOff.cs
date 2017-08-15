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
    public interface IHVDropOff
    {
        // NOTE:  Only a subset of HV API functionality represented here.   See https://docs.microsoft.com/en-us/dotnet/api/microsoft.health.package.connectpackage?view=healthvaultnet-2.64.20508.1.
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
