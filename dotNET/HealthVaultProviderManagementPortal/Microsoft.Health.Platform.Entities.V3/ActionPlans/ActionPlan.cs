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
    /// An action plan being created for a user
    /// </summary>
    public class ActionPlan
    {
        /// <summary>
        /// The name of the plan, localized
        /// </summary>
        public string Name { get; set; }

        /// <summary>
        /// The description of the plan, localized
        /// </summary>
        public string Description { get; set; }

        /// <summary>
        /// A URL to an image for the plan. Suggested resolution is 212 x 212. URLs should be HTTPS.
        /// </summary>
        public Uri ImageUrl { get; set; }

        /// <summary>
        /// A URL to a thumbnail image for the plan. Suggested resolution is 212 x 212. URLs should be HTTPS.
        /// </summary>
        public Uri ThumbnailImageUrl { get; set; }

        /// <summary>
        /// The ID of the organization that manages this plan
        /// </summary>
        public string OrganizationId { get; set; }

        /// <summary>
        /// The name of the organization that manages this plan
        /// </summary>
        public string OrganizationName { get; set; }

        /// <summary>
        /// A URL to the logo of the organization that manages this plan. URLs should be HTTPS.
        /// </summary>
        public Uri OrganizationLogoUrl { get; set; }

        /// <summary>
        /// A URL to a larger image for the organization logo that may include the wordmark. URLs should be HTTPS.
        /// </summary>
        public Uri OrganizationLongFormImageUrl { get; set; }

        /// <summary>
        /// The category of the plan
        /// </summary>
        public ActionPlanCategory Category { get; set; }

        /// <summary>
        /// The Collection of objectives for the plan
        /// </summary>
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly", Justification = "Set needed for serialization.")]
        public Collection<Objective> Objectives { get; set; }

        /// <summary>
        /// The Tasks associated with this plan
        /// </summary>
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly", Justification = "Set needed for serialization.")]
        public Collection<ActionPlanTask> AssociatedTasks { get; set; }
    }
}