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
    /// The types of outcomes which are supported
    /// </summary>
    public enum ActionPlanOutcomeType
    {
        /// <summary>
        /// The outcome type is not known
        /// </summary>
        Unknown,

        /// <summary>
        /// The outcome type is "steps per day"
        /// </summary>
        StepsPerDay,

        /// <summary>
        /// The outcome type is "calories per day"
        /// </summary>
        CaloriesPerDay,

        /// <summary>
        /// The outcome type is "exercise hours per week"
        /// </summary>
        ExerciseHoursPerWeek,

        /// <summary>
        /// The outcome type is "sleep hours per night"
        /// </summary>
        SleepHoursPerNight,

        /// <summary>
        /// The outcome type is "minutes to fall asleep per night"
        /// </summary>
        MinutesToFallAsleepPerNight,

        /// <summary>
        /// The outcome is some other type
        /// </summary>
        Other,
    }
}