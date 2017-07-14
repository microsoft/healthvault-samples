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

    /// <summary>
    /// An entry on the timeline
    /// </summary>
    public class TimelineTask
    {
        /// <summary>
        /// ID of the task this timeline task is associated with
        /// </summary>
        public Guid TaskId { get; set; }

        /// <summary>
        /// Name of the task
        /// </summary>
        public string TaskName { get; set; }

        /// <summary>
        /// Type of the task
        /// </summary>
        public TaskType TaskType { get; set; }

        /// <summary>
        /// Task image URL
        /// </summary>
        public string TaskImageUrl { get; set; }

        /// <summary>
        /// Collection of timeline snapshots for the task
        /// </summary>
        public List<TimelineSnapshot> TimelineSnapshots { get; set; }
    }
}