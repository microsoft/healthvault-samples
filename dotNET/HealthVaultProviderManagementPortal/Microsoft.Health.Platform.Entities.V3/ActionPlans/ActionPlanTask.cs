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
    using Microsoft.Health.Platform.Entities.V3.Enums;

    /// <summary>
    /// An action a user should complete.
    /// Adherence to a plan is measured by completion statistics against tasks
    /// </summary>
    public class ActionPlanTask
    {
        /// <summary>
        /// Gets or sets the friendly name of the task
        /// </summary>
        public string Name { get; set; }

        /// <summary>
        /// Gets or sets the short description of the task
        /// </summary>
        public string ShortDescription { get; set; }

        /// <summary>
        /// Gets or sets the detailed description of the task
        /// </summary>
        public string LongDescription { get; set; }

        /// <summary>
        /// Gets or sets the image url of the task
        /// </summary>
        public Uri ImageUrl { get; set; }

        /// <summary>
        /// Gets or sets the thumbnail image url of the task
        /// </summary>
        public Uri ThumbnailImageUrl { get; set; }

        /// <summary>
        /// Gets or sets the ID of the organization that owns this task
        /// </summary>
        public string OrganizationId { get; set; }

        /// <summary>
        /// Gets or sets the organization name that owns this task
        /// </summary>
        public string OrganizationName { get; set; }

        /// <summary>
        /// Gets or sets the type of the task
        /// </summary>
        public ActionPlanTaskType TaskType { get; set; }

        /// <summary>
        /// Gets or sets the tracking policy
        /// </summary>
        public ActionPlanTrackingPolicy TrackingPolicy { get; set; }

        /// <summary>
        /// The text shown during task signup.
        /// </summary>
        public string SignupName { get; set; }

        /// <summary>
        /// Gets or sets the ID of the associated plan
        /// </summary>
        public string AssociatedPlanId { get; set; }

        /// <summary>
        ///  Gets or sets the list of objective IDs the task is associated with
        /// </summary>
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly", Justification = "Setter needed for serialization")]
        public Collection<string> AssociatedObjectiveIds { get; set; }

        /// <summary>
        /// The Completion Type of the Task
        /// </summary>
        public ActionPlanTaskCompletionType CompletionType { get; set; }

        /// <summary>
        /// Completion metrics for frequency based tasks
        /// </summary>
        public ActionPlanFrequencyTaskCompletionMetrics FrequencyTaskCompletionMetrics { get; set; }

        /// <summary>
        /// Completion metrics for schedule based tasks
        /// </summary>
        public ActionPlanScheduledTaskCompletionMetrics ScheduledTaskCompletionMetrics { get; set; }
    }
}