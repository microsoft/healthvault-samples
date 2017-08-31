//
//  EditHabitViewController.swift
//  ActionPlanSample
//
//  Copyright (c) Microsoft Corporation.  All rights reserved.
//  MIT License
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the ""Software""), to deal
//  in the Software without restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
//  and to permit persons to whom the Software is furnished to do so, subject to the
//  following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or
//  substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
//  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
//  PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
//  FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
//  OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.

import UIKit
import HealthVault

enum TableSection: Int
{
    case name
    case schedule
    case reminders
}

enum WindowType: Int
{
    case daily = 0
    case weekly
}

class EditHabitViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet var tableView: UITableView!
    
    private let tableViewController = UITableViewController()
    private var taskInstance: MHVActionPlanTaskInstance?
    private var originalTaskInstance: MHVActionPlanTaskInstance?
    private let reminderOffsetMap = [
        MHVScheduleReminderStateEnum.mhvOnTime() : 0,
        MHVScheduleReminderStateEnum.mhvBefore5Minutes() : -300,
        MHVScheduleReminderStateEnum.mhvBefore10Minutes() : -600,
        MHVScheduleReminderStateEnum.mhvBefore15Minutes() : -900,
        MHVScheduleReminderStateEnum.mhvBefore30Minutes() : -1800,
        MHVScheduleReminderStateEnum.mhvBefore1Hour() : -3600,
        MHVScheduleReminderStateEnum.mhvBefore2Hours() : -7200,
        MHVScheduleReminderStateEnum.mhvBefore4Hours() : -14400,
        MHVScheduleReminderStateEnum.mhvBefore8Hours() : -28800
    ]
    private let dayOfWeekMap = [
        MHVScheduleScheduledDaysEnum.mhvMonday() : "Mo",
        MHVScheduleScheduledDaysEnum.mhvTuesday() : "Tu",
        MHVScheduleScheduledDaysEnum.mhvWednesday() : "We",
        MHVScheduleScheduledDaysEnum.mhvThursday() : "Th",
        MHVScheduleScheduledDaysEnum.mhvFriday() : "Fr",
        MHVScheduleScheduledDaysEnum.mhvSaturday() :  "Sa",
        MHVScheduleScheduledDaysEnum.mhvSunday() : "Su"
    ]
    private let windowTypeMap = [
        MHVActionPlanFrequencyTaskCompletionMetricsWindowTypeEnum.mhvDaily() : WindowType.daily,
        MHVActionPlanFrequencyTaskCompletionMetricsWindowTypeEnum.mhvWeekly() : WindowType.weekly
    ]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Override the back functionality so we can save before navigating back
        let backSpace = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        backSpace.width = -8
        let backButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "back-icon"), style: .plain, target: self, action: #selector(backButtonPressed))
        self.navigationItem.leftBarButtonItems = [backSpace, backButton];
        
        // Add a table view controller so the table view will scroll content that could be covered by the picker views
        self.addChildViewController(self.tableViewController)
        self.tableViewController.didMove(toParentViewController: self)
        self.tableViewController.tableView = self.tableView
    }
    
    public func setTaskInstance(taskInstance: MHVActionPlanTaskInstance?)
    {
        self.taskInstance = taskInstance
        
        if let originalTaskInstance = taskInstance?.copy() as? MHVActionPlanTaskInstance
        {
            self.originalTaskInstance = originalTaskInstance
        }
        
        self.updateTableSections(tableSections: [.name, .schedule, .reminders])
    }
    
    // MARK: - HealthVault
    
    // MARK: - Reading
    
    private func isFrequencyBasedTask() -> Bool
    {
        return self.taskInstance?.completionType == .mhvFrequency()
    }
    
    private func numberOfValidSchedules() -> Int
    {
        var count = 0
        
        self.taskInstance?.schedules?.forEach(
            { (schedule) in
        
                // Make sure the schedule is valid before incrementing the count if invalid schedules should not be counted.
                // An invalid schedule is missing scheduled days of the week or a scheduled time.
                if (schedule.scheduledDays != nil &&
                    schedule.scheduledTime != nil)
                {
                    count += 1
                }
        })
        
        return count
    }
    
    private func scheduleAtIndex(index: Int) -> MHVSchedule?
    {
        if let schedules = self.taskInstance?.schedules
        {
            guard index < schedules.count else
            {
                return nil
            }
            
            return schedules[index]
        }
        
        return nil
    }
    
    private func reminderDateAtIndex(index: Int) -> Date?
    {
        if let schedule = self.scheduleAtIndex(index: index)
        {
            if let timeInterval = self.reminderOffsetMap[schedule.reminderState]
            {
                return schedule.scheduledTime?.toDate().addingTimeInterval(TimeInterval(timeInterval))
            }
            return schedule.scheduledTime?.toDate()
        }
        
        return nil
    }
    
    private func scheduledDateAtIndex(index: Int) -> Date?
    {
        if let schedule = self.scheduleAtIndex(index: index)
        {
            return schedule.scheduledTime?.toDate()
        }
        
        return nil
    }
    
    private func isReminderOnAtIndex(index: Int) -> Bool
    {
        if let schedule = self.scheduleAtIndex(index: index)
        {
            return schedule.reminderState != .mhvOff() && schedule.reminderState != .mhvUnknown()
        }
        
        return false
    }
    
    private func daysStringAtIndex(index: Int) -> String?
    {
        if let schedule = self.scheduleAtIndex(index: index)
        {
            return daysString(schedule: schedule)
        }
        
        return nil
    }
    
    // Parses all MHVSchedule objects to generate a single, human readable string that represents the frequency of a task.
    private func frequencyString() -> String?
    {
        var windowString = "day"
        
        if (self.taskInstance?.frequencyTaskCompletionMetrics?.windowType == .mhvWeekly())
        {
            windowString = "week"
        }
        
        var frequencyString = "1"
        
        if let frequency = self.taskInstance?.frequencyTaskCompletionMetrics?.occurrenceCount
        {
            frequencyString = frequency.stringValue
        }
        
        return "Do this " + frequencyString + "x per " + windowString
    }
    
    // Parses an MHVSchedule and generates a single, human readable, ordered 'days of the week' string.
    private func daysString(schedule: MHVSchedule?) -> String?
    {
        if let days = schedule?.scheduledDays
        {
            if (days.contains(.mhvEveryday()))
            {
                return "Everyday"
            }
            else if (days.count == 2 &&
                     days.contains(.mhvSaturday()) &&
                     days.contains(.mhvSunday()))
            {
                return "Weekends"
            }
            else if (days.count == 5 &&
                    !days.contains(.mhvSaturday()) &&
                    !days.contains(.mhvSunday()))
            {
                return "Weekdays"
            }
            
            var orderedDays = ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]
            var daysOfWeek: [MHVScheduleScheduledDaysEnum : String] = self.dayOfWeekMap
            
            for day in days
            {
                daysOfWeek.removeValue(forKey: day)
            }
            
            orderedDays = orderedDays.filter({ !daysOfWeek.values.contains($0)})
            
            return orderedDays.joined(separator: ", ")
        }
        
        return nil
    }
    
    // MARK: - Updating
    
    private func updateTaskCompletionType(isScheduled: Bool)
    {
        var completionType = MHVActionPlanTaskInstanceCompletionTypeEnum.mhvFrequency()
        
        if (isScheduled)
        {
            // A previously 'frequency based' task may have one or more invalid schedules;
            // repair any invalid schedules by addind missing times or days
            var hourOffset = 0
            
            self.taskInstance?.schedules?.forEach(
                { (schedule) in
                
                    if (schedule.scheduledTime == nil)
                    {
                        // If there are multiple schedules with no time, add the hour offset to the current time
                        // so schedules don't all have the same time.
                        schedule.scheduledTime = MHVTime(date: Date().addingTimeInterval(TimeInterval(hourOffset)))
                    }
                    
                    if (schedule.scheduledDays == nil || schedule.scheduledDays!.isEmpty)
                    {
                        schedule.scheduledDays = [.mhvEveryday()]
                    }
                    
                    hourOffset += 3600
            })
            
            completionType = .mhvScheduled()
        }
        else if (self.taskInstance?.frequencyTaskCompletionMetrics == nil)
        {
            // A previously 'scheduled' task might not have a frequencyTaskCompletionMetrics object;
            // in this case create a new one and default to 1x per day.
            self.updateFrequencyTaskCompletionMetrics(occurenceCount: 1, windowType: .mhvDaily())
        }
        
        self.taskInstance?.completionType = completionType
    }
    
    private func updateFrequencyTaskCompletionMetrics(occurenceCount: Int?, windowType: MHVActionPlanFrequencyTaskCompletionMetricsWindowTypeEnum)
    {
        let frequencyTaskCompletionMetrics = MHVActionPlanFrequencyTaskCompletionMetrics()
        frequencyTaskCompletionMetrics.occurrenceCount = occurenceCount as NSNumber?
        frequencyTaskCompletionMetrics.windowType = windowType
        
        self.taskInstance?.frequencyTaskCompletionMetrics = frequencyTaskCompletionMetrics
    }
    
    public func updateReminder(index: Int, reminderState: MHVScheduleReminderStateEnum?)
    {
        if let schedule = self.scheduleAtIndex(index: index)
        {
            if let state = reminderState
            {
                schedule.reminderState = state
            }
            else
            {
                schedule.reminderState = .mhvOff()
            }
        }
    }
    
    private func deleteSchedule(index: Int)
    {
        if let _ = self.scheduleAtIndex(index: index)
        {
            self.taskInstance?.schedules?.remove(at: index)
        }
    }
    
    private func updateTaskInstance()
    {
        guard let client = HVConnection.currentConnection?.remoteMonitoringClient(), self.taskInstance != nil else
        {
            var errorMessage = "The task instance is nil."
            
            if (self.taskInstance != nil)
            {
                errorMessage = "The remote monitoring client is nil."
            }
            
            self.showAlertWithError(error: nil, defaultMessage: "An error occurred while attempting to updated the action plan task - " + errorMessage, includeCancel: true, retryAction:nil)
            
            return
        }
        
        self.showWorking()
        
        client.actionPlanTasksUpdate(withActionPlanTask: self.taskInstance!, completion:
            { (taskInstance, error) in
                
                guard error == nil else
                {
                    self.showAlertWithError(error: error, defaultMessage: "An unknown error occurred while attempting to updated the action plan task", includeCancel: true, retryAction:
                        {
                            self.updateTaskInstance()
                    })
                    
                    self.hideWorking()
                    
                    return
                }
                
                // Post a notification that tasks have changed
                NotificationCenter.default.post(name: Constants.TasksChangedNotification, object: nil)
                
                self.navigateBack()
        })
    }
    
    // MARK: - UITableViewDataSource
    
    internal func numberOfSections(in tableView: UITableView) -> Int
    {
        return 3
    }
    
    internal func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if (section == TableSection.schedule.rawValue)
        {
            return "Schedule"
        }
        else if (section == TableSection.reminders.rawValue)
        {
            return "Reminders"
        }
        
        return nil;
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var rowCount = 1
        
        switch section
        {
        case TableSection.schedule.rawValue:
            
            rowCount += 1
            
            // If the task is a 'scheduled task' show all schedule items
            if (!self.isFrequencyBasedTask())
            {
                rowCount += self.numberOfValidSchedules()
            }

        case TableSection.reminders.rawValue:

            rowCount =  self.numberOfValidSchedules()
            
            // If the task is a 'frequency based task' show a cell to add a reminder
            if (self.isFrequencyBasedTask())
            {
                rowCount += 1
            }
            
        default:
            break
        }
        
        return rowCount
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let row = indexPath.row
        
        // The first cell in each row is always static
        switch indexPath.section
        {
        case TableSection.name.rawValue:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
            cell.textLabel?.text = self.taskInstance?.name
            cell.selectionStyle = .none
            return cell
            
        case TableSection.schedule.rawValue:
            
            if (indexPath.row == 0)
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AtSpecificTimesCell", for: indexPath) as! AtSpecificTimesCell
                cell.setCompletionType(isOn: !self.isFrequencyBasedTask(), reloadClosure:
                    { (cell) in
                        self.updateTaskCompletionType(isScheduled:cell.cellSwitch.isOn)
                        self.updateTableSections(tableSections: [.schedule, .reminders])
                })
                return cell
            }
            
        case TableSection.reminders.rawValue:
            
            if (self.isFrequencyBasedTask())
            {
                if (indexPath.row == self.numberOfValidSchedules())
                {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "RightDetailWithDisclosureCell", for: indexPath)
                    cell.textLabel?.text = "Add a reminder"
                    cell.detailTextLabel?.text = nil
                    return cell
                }
                else
                {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "RightDetailWithDisclosureCell", for: indexPath)
                    let date = self.reminderDateAtIndex(index: row)
                    cell.textLabel?.text = self.formattedTimeString(date: date)
                    cell.detailTextLabel?.text = self.isReminderOnAtIndex(index: row) ? self.daysStringAtIndex(index: row) : "Off"
                    return cell
                }
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell", for: indexPath) as! ReminderTableViewCell
            if let schedule = self.scheduleAtIndex(index: row)
            {
                cell.setDate(date:schedule.scheduledTime?.toDate(), offset: self.reminderOffsetMap[schedule.reminderState], sheduleIndex: row, dayString: self.daysStringAtIndex(index: row))
            }
            return cell
            
        default:
            break
        }
        
        if (indexPath.row == 1 && self.isFrequencyBasedTask())
        {
            // If the task is frequency based (e.g 1x per day) show the frequency cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "FrequencyCell", for: indexPath) as! FrequencyTableViewCell
            if let occurrenceCount = self.taskInstance?.frequencyTaskCompletionMetrics?.occurrenceCount,
               let windowType = self.taskInstance?.frequencyTaskCompletionMetrics?.windowType
            {
                if let type = self.windowTypeMap[windowType]
                {
                    cell.setOccurrenceCount(occurrenceCount: Int(occurrenceCount), windowType: type)
                }
            }
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RightDetailWithDisclosureCell", for: indexPath)
        
        if (indexPath.row <= self.numberOfValidSchedules())
        {
            let date = self.scheduledDateAtIndex(index: row - 1)
            cell.textLabel?.text = self.formattedTimeString(date: date)
            cell.detailTextLabel?.text = self.daysStringAtIndex(index: row - 1)
        }
        else
        {
            cell.textLabel?.text = "Add a time"
            cell.detailTextLabel?.text = nil
        }
        
        return cell
    }
    
    // Support for deleting schedules
    internal func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        if (!self.isFrequencyBasedTask() &&
            indexPath.section == 1 &&
            indexPath.row > 0 &&
            indexPath.row <= self.numberOfValidSchedules())
        {
            // Allow deleting schedules in section 1. If task is set to be performed 'At specific times'
            // Schedule items appear in the schedule section and the reminder section. Only allow deletions
            // to occur in the schedule section to avoid accidentally deleting a schedule when trying to
            // remove a reminder.
            return true
        }
        else if (self.isFrequencyBasedTask() &&
                 indexPath.section == 2 &&
                 indexPath.row < self.numberOfValidSchedules())
        {
            // Allow deleting reminders only if the task is set to frequency based. If the task is not
            // set to 'specific times'. allow deletion of a reminder - which will delete the schedule.
            return true
        }
        
        return false
    }
    
    // Support for deleting schedules
    internal func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if (indexPath.section == 1)
        {
            // The task is set to 'At specific times' - Delete the schedule and refresh both
            // The schedule section and the reminder section.
            let index = indexPath.row - 1
            
            self.deleteSchedule(index: index)
            
            self.updateTableSections(tableSections: [.schedule, .reminders])
        }
        else
        {
            // The task is frequency based - Delete the schedule and refresh the reminders section
            self.deleteSchedule(index: indexPath.row)
            
            self.updateTableSections(tableSections: [.reminders])
        }
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Helpers
    
    private func formattedTimeString(date: Date?) -> String?
    {
        if let d = date
        {
            let formatter = DateFormatter()
            formatter.dateStyle = .none
            formatter.timeStyle = .short
            
            return formatter.string(from: d)
        }
        
        return nil
    }
    
    private func updateTableSections(tableSections: [TableSection])
    {
        DispatchQueue.main.async
            {
                if (!self.isViewLoaded)
                {
                    return
                }
                
                let indexSet = IndexSet(tableSections.map{ $0.rawValue})
                self.tableView.reloadSections(indexSet, with: .automatic)
        }
    }
    
    private func cellDidUpdate(cell: UITableViewCell?)
    {
        guard cell != nil else
        {
            // No cell found - Reload all sections
            self.updateTableSections(tableSections: [.name, .schedule, .reminders])
            return
        }
        
        let indexPath = self.tableView.indexPath(for: cell!)
        
        guard indexPath != nil else
        {
            // The cell was not found in the table - Reload all sections
            self.updateTableSections(tableSections: [.name, .schedule, .reminders])
            return
        }
        
        self.updateTableSections(tableSections: [TableSection(rawValue: indexPath!.section)!])
    }
    
    private func enumForValue<T: MHVEnum, U:Equatable>(value: U?, dictionary:[T : U]) -> T?
    {
        if (value == nil)
        {
            return nil
        }
        
        for (key, val) in dictionary
        {
            if (val == value)
            {
                return key
            }
        }
        
        return nil
    }
    
    // MARK: - Actions
    
    @IBAction func textFieldDidBeginEditing(sender: PickerTextField)
    {
        // Disable the back button while the picker is being displayed.
        self.navigationItem.leftBarButtonItems?[1].isEnabled = false
    }
    
    @IBAction func textFieldDidEndEditing(sender: PickerTextField)
    {
        if let frequencyField = sender as? FrequencyTextField
        {
            if let windowType = self.enumForValue(value: frequencyField.windowType, dictionary: self.windowTypeMap)
            {
                self.updateFrequencyTaskCompletionMetrics(occurenceCount: frequencyField.occurrenceCount, windowType: windowType)
            }
        }
        
        if let reminderField = sender as? ReminderTextField
        {
            if let reminderState = self.enumForValue(value: reminderField.offset, dictionary: self.reminderOffsetMap)
            {
                self.updateReminder(index: reminderField.scheduleIndex, reminderState: reminderState)
            }
            else
            {
                self.updateReminder(index: reminderField.scheduleIndex, reminderState: nil)
            }
        }
        
        // Enable the back button once the picker is dismissed.
        self.navigationItem.leftBarButtonItems?[1].isEnabled = true
    }
    
    func backButtonPressed()
    {
        // No changes have been made - Just navigate back
        if (self.taskInstance == self.originalTaskInstance)
        {
            self.navigateBack()
        }
        else
        {
            self.updateTaskInstance()
        }
    }
    
    // MARK: - Navigation
    
    private func navigateBack()
    {
        DispatchQueue.main.async
            {
                 self.performSegue(withIdentifier: "UnwindFromEditHabit", sender: self)
        }
    }
    
    @IBAction func prepareForUnwindFromEditTime(segue: UIStoryboardSegue)
    {
        self.updateTableSections(tableSections: [.schedule, .reminders])
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let cell = sender as? UITableViewCell
        {
            if  let indexPath = self.tableView.indexPath(for: cell)
            {
                var index = indexPath.row
                var isReminder = true
                
                if (indexPath.section == TableSection.schedule.rawValue)
                {
                    index -= 1
                    isReminder = false
                }
                
                if let editTimeViewController = segue.destination as? EditTimeViewController
                {
                    editTimeViewController.setTaskInstance(taskInstance: self.taskInstance, index: index, isReminder: isReminder)
                }
            }
        }
    }
    
}
