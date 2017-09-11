// Copyright (c) Microsoft Corporation.  All rights reserved.
// MIT License
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the ""Software""), to deal
// in the Software without restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
// and to permit persons to whom the Software is furnished to do so, subject to the
// following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or
// substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
// PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
// FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
// DEALINGS IN THE SOFTWARE.

import Foundation
import HealthVault

// Data needed for the UI for a Timeline TableView Cell
// A MHVTimelineTask is converted to this class to store data needed for the cell UI
class TimelineTaskCellData: NSObject
{
    private(set) var taskId: String?
    private(set) var taskName: String?
    private(set) var taskDescription: String?
    private(set) var taskTimes: String?
    private(set) var imageUrl: URL?
    private(set) var occurrenceCount: Int = 0
    private(set) var requiredNumberOfOccurrences: Int = 1
    private(set) var frequency: String?
    private(set) var hasReminder: Bool = true
    private(set) var isOutOfWindow: Bool = false
    private(set) var sortDate: Date?
    private(set) var schedules: [MHVTimelineSchedule]?
    private(set) var occurrenceIdentifiers = [String]()

    @objc dynamic var isWorking: Bool = false
    var undoTimer: Timer?

    private let dayOfWeekMap = [MHVScheduleScheduledDaysEnum.mhvSunday() : 1,
                                MHVScheduleScheduledDaysEnum.mhvMonday() : 2,
                                MHVScheduleScheduledDaysEnum.mhvTuesday() : 3,
                                MHVScheduleScheduledDaysEnum.mhvWednesday() : 4,
                                MHVScheduleScheduledDaysEnum.mhvThursday() : 5,
                                MHVScheduleScheduledDaysEnum.mhvFriday() : 6,
                                MHVScheduleScheduledDaysEnum.mhvSaturday() :  7]
    
    /// Initialize the data for a timeline cell from a MHVTimelineTask
    /// The timeline task is processed to calculate the UI values to display
    ///
    /// - Parameter task: MHVTimelineTask to be used for the cell
    init(task: MHVTimelineTask, schedules: [MHVTimelineSchedule])
    {
        //Save properties
        self.taskId = task.taskId
        self.taskName = task.taskName
        self.taskDescription = task.taskName
        
        if let imageUrl = task.taskImageUrl, let url = URL.init(string: imageUrl)
        {
            self.imageUrl = url
        }
        
        // Check schedules and occurrences to show correct counts in trackTaskButton
        self.requiredNumberOfOccurrences = schedules.count
        
        // Check schedules to show times under the task name
        if let snapshot = task.timelineSnapshots?.first
        {
            let calendar = Calendar.current
            let startOfDay = calendar.startOfDay(for: Date())
            let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)
            var taskTimesArray = [String]()
            
            //Calculate occurrenceCount & task times
            for schedule in schedules
            {
                if let occurrences = schedule.occurrences
                {
                    for occurrence in occurrences
                    {
                        if let inWindow = occurrence.inWindow,
                            inWindow.boolValue == true || snapshot.completionMetrics?.completionType == MHVTimelineSnapshotCompletionMetricsCompletionTypeEnum.mhvFrequency()
                        {
                            self.occurrenceCount += 1

                            if let identifier = occurrence.identifier
                            {
                                self.occurrenceIdentifiers.append(identifier)
                            }
                        }
                    }
                }

                if let date = schedule.localDateTime?.date,
                    date > startOfDay && date < endOfDay!
                {
                    //LocalTime, so treat as GMT
                    let formatter = DateFormatter.init()
                    formatter.dateFormat = "h:mm a"
                    formatter.timeZone = TimeZone.init(abbreviation: "GMT")
                    
                    taskTimesArray.append(formatter.string(from: date))
                }
            }

            if let schedule = schedules.first
            {
                // Has a schedule, calculate the time description and save the date
                if let date = schedule.localDateTime?.date
                {
                    self.sortDate = date
                }
                
                if schedule.type == MHVTimelineScheduleTypeEnum.mhvAnytime() ||
                    snapshot.completionMetrics?.completionType == MHVTimelineSnapshotCompletionMetricsCompletionTypeEnum.mhvFrequency()
                {
                    self.taskTimes = "Anytime"
                    self.sortDate = Date.distantPast
                }
                else if schedule.type == MHVTimelineScheduleTypeEnum.mhvUnscheduled()
                {
                    self.taskTimes = "Not scheduled"
                    self.sortDate = Date.distantPast
                }
                else
                {
                    self.taskTimes = taskTimesArray.joined(separator: ", ")
                }
            }
            else
            {
                // No schedule, show as Anytime task
                self.taskTimes = "Anytime"
                self.sortDate = Date.distantPast
            }
            
            self.schedules = schedules
            
            // Check completionMetrics if task is daily or weekly, and to find the number of occurrences
            if let completionMetrics = snapshot.completionMetrics
            {
                if let recurrenceType = completionMetrics.recurrenceType
                {
                    if recurrenceType == .mhvDaily()
                    {
                        self.frequency = "day"
                    }
                    else if recurrenceType == .mhvWeekly()
                    {
                        self.frequency = "week"
                    }
                    else
                    {
                        self.frequency = recurrenceType.stringValue
                    }
                }
                
                self.requiredNumberOfOccurrences = completionMetrics.requiredNumberOfOccurrences != nil ? Int(completionMetrics.requiredNumberOfOccurrences!) : 1
            }
        }
    }
    
    /// Fill additional data for a timeline cell from a MHVActionPlanTaskInstance
    ///
    /// - Parameter taskInstance: The task instance
    public func setTaskInstance(taskInstance: MHVActionPlanTaskInstance)
    {
        // Compare with schedule to see if there are reminders set
        calculateReminderFlag(schedules: taskInstance.schedules)
        
        // Timeline only has name, use description from Task
        taskDescription = taskInstance.shortDescription
    }
    
    /// Set that this cell is showing an out-of-window occurrence
    ///
    /// - Parameter date: Date that the task was tracked
    public func setOutOfWindowOccurrence(_ date: Date, identifier: String)
    {
        let formatter = DateFormatter.init()
        formatter.dateFormat = "h:mm a"
        formatter.timeZone = TimeZone.init(abbreviation: "GMT")

        self.taskTimes = formatter.string(from: date)
        self.occurrenceCount = 1
        self.occurrenceIdentifiers.append(identifier)
        self.isOutOfWindow = true
        self.sortDate = date
    }

    /// Compare the Timeline to the Schedule
    /// This determines if the Timeline item's matching Schedule item has a reminder & sets the hasReminder flag
    ///
    /// - Parameter date: Date to be checked
    private func calculateReminderFlag(schedules: [MHVSchedule]?)
    {
        hasReminder = false
        
        //Out-of-window occurrences aren't at a scheduled time, so should not show the "no-reminder" icon
        if isOutOfWindow
        {
            hasReminder = true
            return
        }
        
        guard schedules != nil && self.schedules != nil else
        {
            return
        }

        // Loop through the task's schedule
        for schedule: MHVSchedule in schedules!
        {
            guard let scheduleTimeComponents = schedule.scheduledTime?.toComponents() else
            {
                continue
            }
            
            //Check if reminders are set for the schedule item
            guard schedule.reminderState != MHVScheduleReminderStateEnum.mhvOff() &&
                schedule.reminderState != MHVScheduleReminderStateEnum.mhvUnknown() else
            {
                continue
            }
            
            // Loop through the timeline items
            for timeline: MHVTimelineSchedule in self.schedules!
            {
                if let localDateTime = timeline.localDateTime,
                   let scheduledDays = schedule.scheduledDays
                {
                    //Need to convert localDateTime (in UTC) to components
                    let timeZoneOffsetSeconds = TimeZone.current.secondsFromGMT(for: localDateTime.date!)
                    let targetDate = localDateTime.date.addingTimeInterval(Double(-timeZoneOffsetSeconds))
                    let components = Calendar.current.dateComponents([.minute, .hour, .weekday], from: targetDate)
                    
                    // For each scheduled day, check if the days enum on the schedule contain the current timeline day & time matches
                    for daysEnum: MHVScheduleScheduledDaysEnum in scheduledDays
                    {
                        if scheduledDaysEnumIsEqualToCalendarComponent(daysEnum, weekday: components.weekday!) &&
                            Int(components.hour!) == Int(scheduleTimeComponents.hour!) &&
                            Int(components.minute!) == Int(scheduleTimeComponents.minute!)
                        {
                            hasReminder = true
                            return
                        }
                    }
                }
            }
        }
    }
    
    /// Method to determine if a date is in the tracking window for the task
    /// Scheduled date +/- adherenceDelta
    ///
    /// - Parameter date: Date to be checked
    /// - Returns: whether the date is within the tracking window
    func isTrackingInWindow(date: Date) -> Bool
    {
        let timeZoneOffsetSeconds = TimeZone.current.secondsFromGMT(for: date)
        
        guard let schedules = self.schedules else
        {
            return false
        }

        for schedule: MHVTimelineSchedule in schedules
        {
            if let localDateTime = schedule.localDateTime, let adherenceDelta = schedule.adherenceDelta
            {
                //Date parameter is UTC, convert schedule time to UTC for comparing
                let targetDate = localDateTime.date.addingTimeInterval(Double(-timeZoneOffsetSeconds))
                
                let durationInSeconds = convertToTimeInterval(mhvDateTimeDuration: adherenceDelta)
                
                if date >= targetDate.addingTimeInterval(TimeInterval(-durationInSeconds)) &&
                    date <= targetDate.addingTimeInterval(TimeInterval(durationInSeconds))
                {
                    return true
                }
            }
        }
        
        return false
    }
    
    // Convert an MHVDateTimeDuration value into a TimeInterval duration in seconds
    private func convertToTimeInterval(mhvDateTimeDuration: MHVDateTimeDuration) -> TimeInterval
    {
        //MHVDateTimeDuration is duration since base date of 2000-01-01 0:00:00 UTC
        var dateComonents = DateComponents()
        dateComonents.year = 2000
        dateComonents.month = 1
        dateComonents.day = 1
        dateComonents.hour = 0
        dateComonents.minute = 0
        dateComonents.second = 0
        dateComonents.timeZone = TimeZone(secondsFromGMT: 0)
        
        guard let baseDate = Calendar.current.date(from: dateComonents) else
        {
            return 0
        }
        
        return mhvDateTimeDuration.date.timeIntervalSince(baseDate)
    }
    
    // Determine if the MHVScheduleScheduledDaysEnum matches the CalendarComponent.weekday value
    private func scheduledDaysEnumIsEqualToCalendarComponent(_ dayEnum: MHVScheduleScheduledDaysEnum, weekday: Int) -> Bool
    {
        if dayEnum == .mhvEveryday()
        {
            return true
        }
        
        if let scheduledWeekday = dayOfWeekMap[dayEnum]
        {
            return scheduledWeekday == weekday
        }
        
        return false
    }

    /// Method to perform when a task has been tracked in HealthVault
    /// It checks if the occurrence was in window, and if so it increments the occurrenceCount
    ///
    /// - Parameter date: Date when the task was tracked
    /// - Returns: true if the cellData updated the occurrenceCount and an associated view can be refreshed without reloading the timeline
    ///            false if the timeline should be reloaded
    func updateIfTrackedTaskInWindow(date: Date) -> Bool
    {
        if self.isTrackingInWindow(date: date) && self.requiredNumberOfOccurrences == 1
        {
            self.occurrenceCount += 1
            return true
        }
        return false
    }
}

