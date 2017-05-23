// Copyright (c) Microsoft Corporation.  All rights reserved.
// MIT License
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ""Software""), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.Health;
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
            return (items);
        }
    }
}