// Copyright (c) Microsoft Corporation.  All rights reserved. 
// MIT License
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ""Software""), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

namespace Microsoft.Health.Platform.Entities.V3.ActionPlans
{
    using System;
    using System.Collections.ObjectModel;

    /// <summary>
    /// A summary of a tasks weekly adherence
    /// </summary>
    public class WeeklyAdherenceSummary
    {
        /// <summary>
        /// The start of the week
        /// </summary>
        public DateTimeOffset WeekStart { get; set; }

        /// <summary>
        /// The # of completions that occurred this week
        /// </summary>
        public int Completions { get; set; }

        /// <summary>
        /// The # of completions that were intended for this week
        /// </summary>
        public int IntendedCompletions { get; set; }

        /// <summary>
        /// The # of occurrences that were intended for this week
        /// </summary>
        public int IntendedOccurrences { get; set; }

        /// <summary>
        /// The # of occurrences that were manually tracked this week
        /// </summary>
        public int ManualTrackedOccurrences { get; set; }

        /// <summary>
        /// The # of occurrences that were automatically tracked this week
        /// </summary>
        public int AutomaticTrackedOccurrences { get; set; }

        /// <summary>
        /// A list of evidence (HealthVault Thing IDs) that were automatically tracked
        /// </summary>
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly", Justification = "Setter needed for serialization")]
        public Collection<string> AutomaticTrackedOccurrenceEvidence { get; set; }
    }
}
