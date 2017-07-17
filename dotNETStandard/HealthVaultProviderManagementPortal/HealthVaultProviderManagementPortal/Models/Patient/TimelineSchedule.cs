// Copyright (c) Microsoft Corporation.  All rights reserved.
// MIT License
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ""Software""), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

namespace HealthVaultProviderManagementPortal.Models.Patient
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Enums;
    using NodaTime;

    /// <summary>
    /// The schedule for the timeline entry
    /// </summary>
    public class TimelineSchedule
    {
        /// <summary>
        /// The adherence delta for the task
        /// </summary>
        public Duration? AdherenceDelta { get; set; }

        /// <summary>
        /// The local date and time of the schedule
        /// </summary>
        public LocalDateTime LocalDateTime { get; set; }

        /// <summary>
        /// The type of schedule
        /// </summary>
        public TimelineScheduleType Type { get; set; }

        /// <summary>
        /// The recurrence type of the schedule
        /// </summary>
        public ActionPlanScheduleRecurrenceType RecurrenceType { get; set; }

        /// <summary>
        /// The occurrences which are bucketed into the schedule
        /// </summary>
        public List<TimelineScheduleOccurrence> Occurrences { get; set; }
    }
}