// Copyright (c) Microsoft Corporation.  All rights reserved. 
// MIT License
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ""Software""), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

namespace Microsoft.Health.Platform.Entities.V3.Enums
{
    /// <summary>
    /// The day for an action plan schedule
    /// </summary>
    public enum ActionPlanScheduleDay
    {
        /// <summary>
        /// The schedule day is not known
        /// </summary>
        Unknown = 0,

        /// <summary>
        /// The task is scheduled for every day of the week
        /// </summary>
        Everyday = 1,

        /// <summary>
        /// The task is scheduled for Sunday
        /// </summary>
        Sunday = 2,

        /// <summary>
        /// The task is scheduled for Monday
        /// </summary>
        Monday = 3,

        /// <summary>
        /// The task is scheduled for Tuesday
        /// </summary>
        Tuesday = 4,

        /// <summary>
        /// The task is scheduled for Wednesday
        /// </summary>
        Wednesday = 5,

        /// <summary>
        /// The task is scheduled for Thursday
        /// </summary>
        Thursday = 6,

        /// <summary>
        /// The task is scheduled for Friday
        /// </summary>
        Friday = 7,

        /// <summary>
        /// The task is scheduled for Saturday
        /// </summary>
        Saturday = 8,
    }
}