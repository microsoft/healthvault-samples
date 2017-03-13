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
    using Microsoft.Health.Platform.Entities.V3.Enums;

    /// <summary>
    /// A tracking object for an Action Plan Task
    /// </summary>
    public class ActionPlanTaskTracking
    {
        /// <summary>
        /// Gets or sets the Id of the task tracking
        /// </summary>
        public string Id { get; set; }

        /// <summary>
        /// Gets or sets the task tracking type
        /// </summary>
        public TrackingType TrackingType { get; set; }

        /// <summary>
        /// Gets or sets the timezone offset of the task tracking, 
        /// if a task is local time based, it should be set as null
        /// </summary>
        public int? TimeZoneOffset { get; set; }

        /// <summary>
        /// Gets or sets the task tracking time
        /// </summary>
        public DateTimeOffset TrackingDateTime { get; set; }

        /// <summary>
        /// Gets or sets the creation time of the task tracking
        /// </summary>
        public DateTimeOffset CreationDateTime { get; set; }

        /// <summary>
        /// Gets or sets the task tracking status
        /// </summary>
        public TaskTrackingStatus TrackingStatus { get; set; }

        /// <summary>
        /// Gets or sets the start time of the occurrence window,
        /// it is null for Completion and OutOfWindow tracking
        /// </summary>
        public DateTimeOffset? OccurrenceStart { get; set; }

        /// <summary>
        /// Gets or sets the end time of the occurrence window,
        /// it is null for Completion and OutOfWindow tracking
        /// </summary>
        public DateTimeOffset? OccurrenceEnd { get; set; }

        /// <summary>
        /// Gets or sets the start time of the completion window
        /// </summary>
        public DateTimeOffset CompletionStart { get; set; }

        /// <summary>
        /// Gets or sets the end time of the completion window
        /// </summary>
        public DateTimeOffset CompletionEnd { get; set; }

        /// <summary>
        /// Gets or sets task Id
        /// </summary>
        public Guid TaskId { get; set; }

        /// <summary>
        /// Gets or sets the tracking feedback
        /// </summary>
        public string Feedback { get; set; }

        /// <summary>
        /// Gets or sets the evidence of the task tracking
        /// </summary>
        public ActionPlanTaskTrackingEvidence Evidence { get; set; }
    }
}