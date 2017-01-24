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
    /// The type of recurrence of a schedule
    /// </summary>
    public enum ActionPlanScheduleRecurrenceType
    {
        /// <summary>
        /// The Recurrence Type is Unknown
        /// </summary>
        Unknown = 0,

        /// <summary>
        /// The Recurrence Type is None
        /// </summary>
        None = 1,

        /// <summary>
        /// Reminder recurs on a minute basis
        /// </summary>
        Minute = 2,

        /// <summary>
        /// Reminder recurs on an hourly basis
        /// </summary>
        Hourly = 3,

        /// <summary>
        /// Reminder recurs on a daily basis
        /// </summary>
        Daily = 4,

        /// <summary>
        /// Reminder recurs on a weekly basis
        /// </summary>
        Weekly = 5,

        /// <summary>
        /// Reminder recurs on a monthly basis
        /// </summary>
        Monthly = 6,

        /// <summary>
        /// Reminder recurs on a yearly basis
        /// </summary>
        Annually = 7,

        /// <summary>
        /// Reminder recurs on a minute basis, since the last occurence
        /// </summary>
        MinutelySinceLast = 8,

        /// <summary>
        /// Reminder recurs on an hourly basis, since the last occurence
        /// </summary>
        HourlySinceLast = 9,

        /// <summary>
        /// Reminder recurs on a daily basis, since the last occurence
        /// </summary>
        DailySinceLast = 10,

        /// <summary>
        /// Reminder recurs on a weekly basis, since the last occurence
        /// </summary>
        WeeklySinceLast = 11,

        /// <summary>
        /// Reminder recurs on a monthly basis, since the last occurence
        /// </summary>
        MonthlySinceLast = 12,

        /// <summary>
        /// Reminder recurs on a yearly basis, since the last occurence
        /// </summary>
        AnnuallySinceLast = 13
    }
}