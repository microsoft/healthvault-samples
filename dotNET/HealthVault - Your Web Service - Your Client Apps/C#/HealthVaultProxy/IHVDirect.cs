using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;

namespace HealthVaultProxy
{
    [ServiceContract]
    public interface IHVDirect
    {
        [OperationContract]
        void DoWork();
    }
}
