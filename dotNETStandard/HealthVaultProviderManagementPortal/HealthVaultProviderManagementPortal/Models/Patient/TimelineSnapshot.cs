// Copyright (c) Microsoft Corporation.  All rights reserved.
// MIT License
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ""Software""), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

namespace HealthVaultProviderManagementPortal.Models.Patient
{
    using System.Collections.Generic;
    using NodaTime;

    /// <summary>
    /// A snapshot of the timeline
    /// </summary>
    public class TimelineSnapshot
    {
        /// <summary>
        /// Collection of schedules for the timeline entry
        /// </summary>
        public List<TimelineSchedule> Schedules { get; set; }

        /// <summary>
        /// Completion metrics specifying the recurrence and type for the timeline entry
        /// </summary>
        public TimelineSnapshotCompletionMetrics CompletionMetrics { get; set; }

        /// <summary>
        /// The occurrences which are marked as out of window and are thus not associated with a schedule
        /// </summary>
        public List<TimelineScheduleOccurrence> UnscheduledOccurrences { get; set; }

        /// <summary>
        /// The effective start time instant for the timeline snapshot
        /// </summary>
        public Instant EffectiveStartInstant { get; set; }

        /// <summary>
        /// The effective end time instant for the timeline snapshot
        /// </summary>
        public Instant EffectiveEndInstant { get; set; }
    }
}