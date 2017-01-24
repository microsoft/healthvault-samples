// Copyright (c) Microsoft Corporation.  All rights reserved. 
// MIT License
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ""Software""), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

namespace Microsoft.Health.Platform.Entities.V3.ActionPlans
{
    using System.Collections.ObjectModel;

    /// <summary>
    /// The tracking properties of a HealthVault event
    /// </summary>
    public class ActionPlanTaskTargetEvent
    {
        /// <summary>
        /// XML XPath to the property for which task should be tracked
        /// </summary>
        public string ElementXPath { get; set; }

        /// <summary>
        /// List of all of the possible values for a given xPath property. (i.e. "run", "running", "walk" etc).
        /// </summary>
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly", Justification = "Set needed for serialization.")]
        public Collection<string> ElementValues { get; set; }

        /// <summary>
        /// Flag to indicate if the condition mentioned above is negated. e.g. Item shouldn't be a run or a walk. 
        /// </summary>
        public bool IsNegated { get; set; }
    }
}