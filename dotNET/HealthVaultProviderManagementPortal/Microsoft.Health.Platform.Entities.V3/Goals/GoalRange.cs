// --------------------------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation.  All rights reserved. 
// MIT License
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ""Software""), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

namespace Microsoft.Health.Platform.Entities.V3.Goals
{
    using Microsoft.Health.Platform.Entities.V3.Enums;

    /// <summary>
    /// The range of achievement for a goal.
    /// </summary>
    public class GoalRange
    {
        /// <summary>
        /// The name of the range.
        /// </summary>
        public string Name { get; set; }

        /// <summary>
        /// The description of the range. Allows more detailed information about the range.
        /// </summary>
        public string Description { get; set; }

        /// <summary>
        /// The minimum value for the range.
        /// For ranges greater than a specified value with no maximum, specify a minimum but no maximum.
        /// </summary>
        public double? Minimum { get; set; }

        /// <summary>
        /// The maximum value for the range.
        /// For ranges less than a specified value with no minimum, specify a maximum but no minimum.
        /// </summary>
        public double? Maximum { get; set; }

        /// <summary>
        /// The units of the range.
        /// </summary>
        public GoalRangeUnit Units { get; set; }
    }
}
