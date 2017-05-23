// Copyright (c) Microsoft Corporation.  All rights reserved.
// MIT License
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ""Software""), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

namespace HealthVaultProviderManagementPortal.Models.Enums
{
    /// <summary>
    /// The available status of task reminders
    /// </summary>
    public enum ActionPlanReminderState
    {
        /// <summary>
        /// The reminder state is not known
        /// </summary>
        Unknown,

        /// <summary>
        /// Reminders are off
        /// </summary>
        Off,

        /// <summary>
        /// Reminders are set at the scheduled time
        /// </summary>
        OnTime,

        /// <summary>
        /// Reminders are set for 5 minutes before the schedule
        /// </summary>
        Before5Minutes,

        /// <summary>
        /// Reminders are set for 10 minutes before the schedule
        /// </summary>
        Before10Minutes,

        /// <summary>
        /// Reminders are set for 15 minutes before the schedule
        /// </summary>
        Before15Minutes,

        /// <summary>
        /// Reminders are set for 30 minutes before the schedule
        /// </summary>
        Before30Minutes,

        /// <summary>
        /// Reminders are set for 1 hour before the schedule
        /// </summary>
        Before1Hour,

        /// <summary>
        /// Reminders are set for 2 hours before the schedule
        /// </summary>
        Before2Hours,

        /// <summary>
        /// Reminders are set for 4 hours before the schedule
        /// </summary>
        Before4Hours,

        /// <summary>
        /// Reminders are set for 8 hours before the schedule
        /// </summary>
        Before8Hours,
    }
}