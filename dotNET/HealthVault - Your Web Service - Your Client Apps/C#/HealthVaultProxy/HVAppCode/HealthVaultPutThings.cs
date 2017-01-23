using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.Health;
using Microsoft.Health.ItemTypes;
using Microsoft.Health.Web;


namespace HVAppCode
{

    public class HealthVaultPutThings    
    {
        public static void PutThings(OfflineWebApplicationConnection connection, Guid recordId, ref HealthRecordItem newItem)
        {
            HealthRecordAccessor record = new HealthRecordAccessor(connection, recordId);
            record.NewItem(newItem);
            return;
        }
    }
}