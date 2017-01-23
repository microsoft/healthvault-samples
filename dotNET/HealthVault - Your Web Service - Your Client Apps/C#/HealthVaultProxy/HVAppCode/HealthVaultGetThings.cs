using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.Health;
using Microsoft.Health.ItemTypes;
using Microsoft.Health.Web;

namespace HVAppCode
{
    public class HealthVaultGetThings
    {
        public static List<string> GetThings(OfflineWebApplicationConnection connection,
                                             Guid recordId, Guid[] typeIds, DateTime updatedSinceUtc)
        {
            HealthRecordAccessor record = new HealthRecordAccessor(connection, recordId);
            HealthRecordSearcher searcher = record.CreateSearcher();
            HealthRecordFilter filter = new HealthRecordFilter();
            searcher.Filters.Add(filter);

            foreach (Guid typeId in typeIds)
                filter.TypeIds.Add(typeId);

            filter.UpdatedDateMin = DateTime.SpecifyKind(updatedSinceUtc, DateTimeKind.Utc);

            filter.View.Sections = HealthRecordItemSections.All | Microsoft.Health.HealthRecordItemSections.Xml;

                //HealthRecordItemSections.Core |
                //HealthRecordItemSections.Xml |
                //HealthRecordItemSections.Audits;

            HealthRecordItemCollection things = searcher.GetMatchingItems()[0];

            List<string> items = new List<string>();
            foreach (HealthRecordItem thing in things)
            {
                items.Add(thing.GetItemXml(filter.View.Sections));
            }
            return(items);
        }
    }
}