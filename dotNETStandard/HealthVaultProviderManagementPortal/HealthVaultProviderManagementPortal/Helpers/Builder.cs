// Copyright (c) Microsoft Corporation.  All rights reserved.
// MIT License
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ""Software""), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using HealthVaultProviderManagementPortal.Models.Enums;
using Microsoft.HealthVault.RestApi.Generated.Models;

namespace HealthVaultProviderManagementPortal.Helpers
{
    public static class Builder
    {
        #region Sleep plan

        /// <summary>
        /// Creates a sample action plan object.
        /// </summary>
        public static ActionPlan CreateSleepActionPlan()
        {
            var objective = CreateSleepObjective();

            // Use this if you want to create the task with the plan in one call.
            // You can also create tasks in a separate call after the action plan is created.
            var scheduledTask = CreateSleepScheduledActionPlanTask(objective.Id);
            var frequencyTask = CreateSleepFrequencyActionPlanTask(objective.Id);

            var plan = new ActionPlan
            {
                Name = "Sleep better",
                Description = "Improve the quantity and quality of your sleep.",
                ImageUrl = "https://img-prod-cms-rt-microsoft-com.akamaized.net/cms/api/am/imageFileData/RE10omP?ver=59cf",
                ThumbnailImageUrl = "https://img-prod-cms-rt-microsoft-com.akamaized.net/cms/api/am/imageFileData/RE10omP?ver=59cf",
                Category = ActionPlanCategory.Sleep.ToString(),
                Objectives = new Collection<Objective> {objective},
                AssociatedTasks = new Collection<ActionPlanTask> {scheduledTask, frequencyTask}
            };

            return plan;
        }

        /// <summary>
        /// Creates a sample action plan objective.
        /// </summary>
        public static Objective CreateSleepObjective()
        {
            var objective = new Objective
            {
                Id = Guid.NewGuid(),
                Name = "Get more sleep",
                Description = "Work on habits that help you maximize how much you sleep you get.",
                State = ActionPlanObjectiveStatus.Active.ToString(),
                OutcomeName = "Minutes to fall asleep/night",
                OutcomeType = ActionPlanOutcomeType.MinutesToFallAsleepPerNight.ToString()
            };

            return objective;
        }

        /// <summary>
        /// Creates a sample schedule based task associated with the specified objective.
        /// </summary>
        public static ActionPlanTask CreateSleepScheduledActionPlanTask(Guid objectiveId, Guid planId = default(Guid))
        {
            var task = new ActionPlanTask
            {
                Name = "Time to wake up",
                ShortDescription = "Set a consistent wake time to help regulate your body's internal clock.",
                LongDescription = "Studies show that waking up at a consistent time every day, even on weekends, is one of the best ways to ensure a good night's sleep.",
                ImageUrl = "https://img-prod-cms-rt-microsoft-com.akamaized.net/cms/api/am/imageFileData/RE1rXx2?ver=d68e",
                ThumbnailImageUrl = "https://img-prod-cms-rt-microsoft-com.akamaized.net/cms/api/am/imageFileData/RE1s2KS?ver=0ad8",
                TaskType = ActionPlanTaskType.Other.ToString(),
                SignupName = "Set a consistent wake time",
                AssociatedObjectiveIds = new Collection<Guid?> { objectiveId },
                AssociatedPlanId = planId, // Only needs to be set if adding as task after the plan
                TrackingPolicy = new ActionPlanTrackingPolicy
                {
                    IsAutoTrackable = false
                },
                CompletionType = ActionPlanTaskCompletionType.Scheduled.ToString(),
                Schedules = new List<Schedule>
                {
                    new Schedule
                    {
                        ReminderState = ActionPlanReminderState.Off.ToString(),
                        ScheduledDays = new Collection<string> { ActionPlanScheduleDay.Everyday.ToString() },
                        ScheduledTime = new Time()
                        {
                            Hours = 6,
                            Minutes = 30
                        }
                    }
                }
            };

            return task;
        }

        /// <summary>
        /// Creates a sample frequency based task associated with the specified objective.
        /// </summary>
        public static ActionPlanTask CreateSleepFrequencyActionPlanTask(Guid? objectiveId, Guid planId = default(Guid))
        {
            var task = new ActionPlanTask
            {
                Name = "Measure your blood pressure",
                ShortDescription = "Measure your blood pressure - the goal is to have your systolic between 80-120 and diastolic between 60-80 mmHg",
                LongDescription = "Measure your blood pressure - the goal is to have your systolic between 80-120 and diastolic between 60-80 mmHg",
                ImageUrl = "https://img-prod-cms-rt-microsoft-com.akamaized.net/cms/api/am/imageFileData/RE1rXx2?ver=d68e",
                ThumbnailImageUrl = "https://img-prod-cms-rt-microsoft-com.akamaized.net/cms/api/am/imageFileData/RE1s2KS?ver=0ad8",
                TaskType = ActionPlanTaskType.BloodPressure.ToString(),
                SignupName = "Measure your blood pressure",
                AssociatedObjectiveIds = new Collection<Guid?> { objectiveId },
                AssociatedPlanId = planId, // Only needs to be set if adding as task after the plan
                TrackingPolicy = new ActionPlanTrackingPolicy
                {
                    IsAutoTrackable = true,
                    OccurrenceMetrics = new ActionPlanTaskOccurrenceMetrics
                    {
                        EvaluateTargets = false
                    },
                    TargetEvents = new Collection<ActionPlanTaskTargetEvent>
                    {
                        new ActionPlanTaskTargetEvent
                        {
                            ElementXPath = "thing/data-xml/blood-pressure"
                        }
                    }
                },
                CompletionType = ActionPlanTaskCompletionType.Frequency.ToString(),
                Schedules = new List<Schedule>
                {
                    new Schedule
                    {
                        ReminderState = ActionPlanReminderState.Off.ToString(),
                        ScheduledDays = new Collection<string> { ActionPlanScheduleDay.Everyday.ToString() }
                    }
                },
                FrequencyTaskCompletionMetrics = new ActionPlanFrequencyTaskCompletionMetrics()
                {
                    OccurrenceCount = 1,
                    WindowType = ActionPlanScheduleRecurrenceType.Daily.ToString()
                }
            };

            return task;
        }

        /// <summary>
        /// Creates a sample goal object.
        /// </summary>
        public static Goal CreateDefaultGoal()
        {
            return new Goal
            {
                Name = "Steps",
                Description = "This is a test steps goal",
                GoalType = GoalType.Steps.ToString(),
                Range = new GoalRange
                {
                    Minimum = 5000,
                    Units = GoalRangeUnit.Count.ToString()
                },
                RecurrenceMetrics = new GoalRecurrenceMetrics
                {
                    OccurrenceCount = 1,
                    WindowType = GoalRecurrenceType.Daily.ToString()
                },
                StartDate = DateTime.UtcNow
            };
        }

        #endregion

        #region Weight ActionPlan

        public static ActionPlan CreateWeightActionPlan()
        {         
            var objective = new Objective
            {
                Id = Guid.NewGuid(),
                Name = "Manage your weight",
                Description = "Manage your weight better by measuring daily. ",
                State = ActionPlanObjectiveStatus.Active.ToString(),
                OutcomeName = "Better control over your weight",
                OutcomeType = ActionPlanOutcomeType.Other.ToString()
            };

            // Use this if you want to create the task with the plan in one call.
            // You can also create tasks in a separate call after the action plan is created.
            var task = CreateDailyWeightMeasurementActionPlanTask(objective.Id);

            var plan = new ActionPlan
            {
                Name = "Track your weight",
                Description = "Daily weight tracking can help you be more conscious of what you eat. ",
                ImageUrl = "https://img-prod-cms-rt-microsoft-com.akamaized.net/cms/api/am/imageFileData/RW680a?ver=b227",
                ThumbnailImageUrl = "https://img-prod-cms-rt-microsoft-com.akamaized.net/cms/api/am/imageFileData/RW6fN6?ver=6479",
                Category = ActionPlanCategory.Health.ToString(),
                Objectives = new Collection<Objective> {objective},
                AssociatedTasks = new Collection<ActionPlanTask> {task}
            };

            return plan;
        }

        /// <summary>
        /// Creates a sample frequency based task associated with the specified objective.
        /// </summary>
        public static ActionPlanTask CreateDailyWeightMeasurementActionPlanTask(Guid? objectiveId, Guid planId = default(Guid))
        {
            var task = new ActionPlanTask
            {
                Name = "Measure your weight",
                ShortDescription = "Measure your weight daily",
                LongDescription = "Measure your weight daily",
                ImageUrl = "https://img-prod-cms-rt-microsoft-com.akamaized.net/cms/api/am/imageFileData/RW680a?ver=b227",
                ThumbnailImageUrl = "https://img-prod-cms-rt-microsoft-com.akamaized.net/cms/api/am/imageFileData/RW6fN6?ver=6479",
                TaskType = ActionPlanTaskType.Other.ToString(),
                SignupName = "Measure your weight",
                AssociatedObjectiveIds = new Collection<Guid?> { objectiveId },
                AssociatedPlanId = planId, // Only needs to be set if adding as task after the plan
                TrackingPolicy = new ActionPlanTrackingPolicy
                {
                    IsAutoTrackable = true,
                    OccurrenceMetrics = new ActionPlanTaskOccurrenceMetrics
                    {
                        EvaluateTargets = false
                    },
                    TargetEvents = new Collection<ActionPlanTaskTargetEvent>
                    {
                        new ActionPlanTaskTargetEvent
                        {
                            ElementXPath = "thing/data-xml/weight",
                        }
                    }
                },
                CompletionType = ActionPlanTaskCompletionType.Frequency.ToString(),
                Schedules = new List<Schedule>
                {
                    new Schedule
                    {
                        ReminderState = ActionPlanReminderState.Off.ToString(),
                        ScheduledDays = new Collection<string> { ActionPlanScheduleDay.Everyday.ToString() }
                    }
                },
                FrequencyTaskCompletionMetrics = new ActionPlanFrequencyTaskCompletionMetrics()
                {
                    OccurrenceCount = 1,
                    WindowType = ActionPlanScheduleRecurrenceType.Daily.ToString()
                }
            };

            return task;
        }

        #endregion
    }
}