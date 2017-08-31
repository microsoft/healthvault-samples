//
//  EditTimeViewController.swift
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

struct Day
{
    public private(set) var dayEnum: MHVScheduleScheduledDaysEnum!
    public private(set) var title: String!
    public var isSelected: Bool
    
    init(dayEnum: MHVScheduleScheduledDaysEnum!, title: String!)
    {
        self.dayEnum = dayEnum
        self.title = title
        self.isSelected = false
    }
}

class EditTimeViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet var tableView: UITableView!
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var navBar: UINavigationBar!

    private var taskInstance: MHVActionPlanTaskInstance?
    private var schedule = MHVSchedule()
    private var originalSchedule: MHVSchedule?
    private var index = -1
    private var isReminder = false
    private var daysOfTheWeek = DateFormatter().weekdaySymbols
    private var days = [Day(dayEnum: MHVScheduleScheduledDaysEnum.mhvEveryday(), title:"Everyday"),
                        Day(dayEnum: MHVScheduleScheduledDaysEnum.mhvSunday(), title:"Sunday"),
                        Day(dayEnum: MHVScheduleScheduledDaysEnum.mhvMonday(), title:"Monday"),
                        Day(dayEnum: MHVScheduleScheduledDaysEnum.mhvTuesday(), title:"Tuesday"),
                        Day(dayEnum: MHVScheduleScheduledDaysEnum.mhvWednesday(), title:"Wednesday"),
                        Day(dayEnum: MHVScheduleScheduledDaysEnum.mhvThursday(), title:"Thursday"),
                        Day(dayEnum: MHVScheduleScheduledDaysEnum.mhvFriday(), title:"Friday"),
                        Day(dayEnum: MHVScheduleScheduledDaysEnum.mhvSaturday(), title:"Saturday")
                        ]
    private let reminderOffsetMap = [MHVScheduleReminderStateEnum.mhvOnTime() : 0,
                                     MHVScheduleReminderStateEnum.mhvBefore5Minutes() : -300,
                                     MHVScheduleReminderStateEnum.mhvBefore10Minutes() : -600,
                                     MHVScheduleReminderStateEnum.mhvBefore15Minutes() : -900,
                                     MHVScheduleReminderStateEnum.mhvBefore30Minutes() : -1800,
                                     MHVScheduleReminderStateEnum.mhvBefore1Hour() : -3600,
                                     MHVScheduleReminderStateEnum.mhvBefore2Hours() : -7200,
                                     MHVScheduleReminderStateEnum.mhvBefore4Hours() : -14400,
                                     MHVScheduleReminderStateEnum.mhvBefore8Hours() : -28800
                                    ]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
    }

    public func setTaskInstance(taskInstance: MHVActionPlanTaskInstance?, index: Int, isReminder: Bool)
    {
        self.taskInstance = taskInstance
        self.index = index
        self.isReminder = isReminder
        
        if let count = taskInstance?.schedules?.count
        {
            if (index < count)
            {
                if let schedule = taskInstance?.schedules?[index]
                {
                    self.schedule = schedule.copy() as! MHVSchedule
                    self.originalSchedule = schedule
                }
            }
        }
        
        self.addScheduleData()
        
        self.updateView()
    }
    
    private func updateView()
    {
        self.generateDaysDisplayData()
        
        DispatchQueue.main.async
            {
                if (!self.isViewLoaded)
                {
                    return
                }
                
                // We are creating a new schedule change the title and add a save button.
                if (self.isNew())
                {
                    self.navBar.topItem?.title = "Add new"
                }
                
                if let scheduleCount = self.schedule.scheduledDays?.count
                {
                    // Disable the save button if no days are selected.
                    if (scheduleCount < 1)
                    {
                        self.setSaveButtonEnabled(enabled: false)
                    }
                    else
                    {
                        self.setSaveButtonEnabled(enabled: self.hasEdits())
                    }
                }
                
                self.tableView.reloadData()
        }
    }
    
    // MARK: - HealthVault
    
    private func updateSchedules()
    {
        if var schedules = self.taskInstance?.schedules
        {
            // Add the new schedule or replace the existing one
            if (!self.isNew())
            {
                schedules.remove(at: self.index)
            }
            
            schedules.append(self.schedule)
            self.taskInstance?.schedules = schedules
            self.sortSchedulesByTime()
        }
        else
        {
            self.showAlertWithError(error: nil, defaultMessage: "An error occurred while attempting to updated the action plan task - The task instance or schedules array is nil.", includeCancel: true, retryAction:
                {
                    self.updateSchedules()
            })
            
            return
        }
    }
    
    private func addScheduleData()
    {
        if (self.schedule.scheduledDays == nil)
        {
            self.schedule.scheduledDays = [MHVScheduleScheduledDaysEnum.mhvEveryday()]
        }
        
        if (self.schedule.scheduledTime == nil)
        {
            self.schedule.scheduledTime = MHVTime(date: Date())
        }
        
        if (self.isReminder)
        {
            if (self.isNew() || self.schedule.reminderState == .mhvOff() || self.schedule.reminderState == .mhvUnknown())
            {
                self.schedule.reminderState = .mhvOnTime()
            }
        }
        else if (self.isNew())
        {
            self.schedule.reminderState = .mhvOff()
        }
    }
    
    private func generateDaysDisplayData()
    {
        var index = 0
        
        repeat
        {
            if let isEverydaySelected = self.schedule.scheduledDays?.contains(.mhvEveryday())
            {
                if (isEverydaySelected)
                {
                    self.days[index].isSelected = true
                }
                else
                {
                    if let isSelected = self.schedule.scheduledDays?.contains(self.days[index].dayEnum)
                    {
                        self.days[index].isSelected = isSelected
                    }
                }
            }
            
            index += 1
        }
        while (index < self.days.count)
    }
    
    private func updateScheduledDay(index: Int)
    {
        let isSelected = self.days[index].isSelected
        
        if(index == 0)
        {
            self.setEverydaySelected(isSelected: !isSelected)
            return
        }
        
        if let _ = self.schedule.scheduledDays?.index(of: .mhvEveryday())
        {
            // If the previous selection was everyday set the array to all days
            self.schedule.scheduledDays = [.mhvSunday(), .mhvMonday(), .mhvTuesday(), .mhvWednesday(), .mhvThursday(), .mhvFriday(), .mhvSaturday()]
            
            self.days[0].isSelected = false
        }
        
        // Update the day object is selected property
        self.days[index].isSelected = !isSelected
        
        var selectedCount = 0
        
        self.days.forEach
            { (day) in
                
                if (day.isSelected)
                {
                    selectedCount += 1
                    
                    if let hasDay = self.schedule.scheduledDays?.contains(day.dayEnum)
                    {
                        if (!hasDay)
                        {
                            self.schedule.scheduledDays?.append(day.dayEnum)
                        }
                    }
                }
                else
                {
                    if let removeIndex = self.schedule.scheduledDays?.index(of: day.dayEnum)
                    {
                        self.schedule.scheduledDays?.remove(at: removeIndex)
                    }
                }
        }
        
        // If all days are selected - set the everyday enum.
        if (selectedCount == 7)
        {
            self .setEverydaySelected(isSelected: true)
        }
    }
    
    // Removes all scheduledDays and adds the .mhvEveryday enum.
    private func setEverydaySelected(isSelected: Bool)
    {
        self.schedule.scheduledDays?.removeAll()
        
        if (isSelected)
        {
            self.schedule.scheduledDays?.append(.mhvEveryday())
        }
    }
    
    private func sortSchedulesByTime()
    {
        if var schedules = self.taskInstance?.schedules
        {
            schedules.sort(by:
                { (schedule1, schedule2) -> Bool in
                    
                    if let date1 = schedule1.scheduledTime?.toDate(), let date2 = schedule2.scheduledTime?.toDate()
                    {
                        return date1 < date2
                    }
                    
                    return true
            })
            
            self.taskInstance?.schedules = schedules
        }
    }
    
    private func displayDate() -> Date
    {
        if let date = self.schedule.scheduledTime?.toDate()
        {
            if let offset = self.reminderOffsetMap[self.schedule.reminderState], self.isReminder
            {
                return date.addingTimeInterval(TimeInterval(offset))
            }
            
            return date
        }
        
        return Date()
    }
    
    private func timeMinusReminderOffset(date: Date) -> MHVTime
    {
        if let offset = self.reminderOffsetMap[self.schedule.reminderState], self.isReminder
        {
            return MHVTime(date: date.addingTimeInterval(TimeInterval(-offset)))
        }
        
        return MHVTime(date: date)
    }
    
    // MARK: - UITableViewDataSource
    
    internal func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (section == 1)
        {
            return 8
        }
        
        return 1
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimePickerCell", for: indexPath) as! TimePickerTableViewCell
            cell.picker.date = self.displayDate()
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DayOfTheWeekCell", for: indexPath)
        let day = days[indexPath.row]
        cell.textLabel?.text = day.title
        cell.accessoryType = day.isSelected ? .checkmark : .none
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if (indexPath.section == 0)
        {
            return 217
        }
        
        return 44
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        if (indexPath.section == 0)
        {
            return
        }
        
        self.updateScheduledDay(index: indexPath.row)
        
        self.updateView()
    }

    // MARK: - Actions
    
    @IBAction func pickerValueChanged(sender: UIDatePicker)
    {
        self.schedule.scheduledTime = self.timeMinusReminderOffset(date: sender.date)
        self.setSaveButtonEnabled(enabled: self.hasEdits())
    }

    @IBAction func cancelButtonPressed()
    {
        self.dismiss()
    }
    
    @IBAction func saveButtonPressed()
    {
        self.updateSchedules()
        self.dismiss()
    }
    
    // MARK - Helpers
    
    private func setSaveButtonEnabled(enabled: Bool)
    {
        DispatchQueue.main.async
            {
                self.saveButton.isEnabled = enabled
        }
        
    }
    
    private func hasEdits() -> Bool
    {
        if (self.isNew())
        {
            return true
        }
        
        if let originalTime = self.originalSchedule?.scheduledTime?.toDate(), let newTime = self.schedule.scheduledTime?.toDate()
        {
            if (originalTime != newTime)
            {
                return true
            }
        }
        
        if let originalState = self.originalSchedule?.reminderState
        {
            if (originalState != self.schedule.reminderState)
            {
                return true
            }
        }
        
        if let originalDays = self.originalSchedule?.scheduledDays, let newDays = self.schedule.scheduledDays
        {
            if (originalDays.count != newDays.count)
            {
                return true
            }
            
            return originalDays.sorted(by: {$0.integerValue < $1.integerValue}) != newDays.sorted(by: {$0.integerValue < $1.integerValue})
        }
        
        return false
    }
    
    private func isNew() -> Bool
    {
        return self.originalSchedule == nil
    }

    // MARK: - Navigation
    
    private func dismiss()
    {
        DispatchQueue.main.async
            {
                self.performSegue(withIdentifier: "UnwindFromEditTime", sender: self)
        }
    }
}
