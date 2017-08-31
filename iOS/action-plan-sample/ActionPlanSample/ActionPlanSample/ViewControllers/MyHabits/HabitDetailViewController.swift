//
//  HabitDetailViewController.swift
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

class HabitDetailViewController: BaseViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var imageBackgroundView: UIView!
    @IBOutlet var titleLable: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var scheduleLabel: UILabel!
    @IBOutlet var stopHabitButton: UIButton!
    
    public private(set) var taskInstance: MHVActionPlanTaskInstance?
    private let dayOfWeekMap = [
                                MHVScheduleScheduledDaysEnum.mhvMonday() : "Mo",
                                MHVScheduleScheduledDaysEnum.mhvTuesday() : "Tu",
                                MHVScheduleScheduledDaysEnum.mhvWednesday() : "We",
                                MHVScheduleScheduledDaysEnum.mhvThursday() : "Th",
                                MHVScheduleScheduledDaysEnum.mhvFriday() : "Fr",
                                MHVScheduleScheduledDaysEnum.mhvSaturday() :  "Sa",
                                MHVScheduleScheduledDaysEnum.mhvSunday() : "Su"
    ]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Add a border to the button
        self.stopHabitButton.layer.borderWidth = 1.0
        self.stopHabitButton.layer.borderColor = UIColor.appMediumGray.cgColor
        
        // Round the corners of the background image
        self.imageBackgroundView.layer.cornerRadius = imageBackgroundView.frame.size.height / 2
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.updateView()
    }
    
    public func setTaskInstance(taskInstance: MHVActionPlanTaskInstance)
    {
        self.taskInstance = taskInstance
        
        self.sortSchedulesByTime()
        
        self.updateView()
    }
    
    private func updateView()
    {
        var scheduleText: String?
        
        if (self.isFrequencyBasedTask())
        {
            scheduleText = self.frequencyString()
        }
        else
        {
            scheduleText = self.timesString()
        }
        
        DispatchQueue.main.async
            {
                if (!self.isViewLoaded)
                {
                    return
                }
                
                if (self.taskInstance == nil)
                {
                    self.imageView.image = nil
                    self.titleLable.text = nil
                    self.descriptionLabel.text = nil
                    self.scheduleLabel.text = nil
                    self.setStopHabitButtonEnabled(enabled: false)
                }
                else
                {
                    if let urlString = self.taskInstance?.imageUrl
                    {
                        let url = URL(string: urlString)
                        self.imageView.setImage(url: url!)
                    }
                    else
                    {
                        self.imageView.image = nil
                    }
                    
                    self.titleLable.text = self.taskInstance?.name
                    self.descriptionLabel.text = self.taskInstance?.longDescription
                    self.scheduleLabel.text = scheduleText
                    self.setStopHabitButtonEnabled(enabled: true)
                }
                
                
        }
    }
    
    // MARK: - HealthVault
    
    private func stopHabit()
    {
        guard let client = HVConnection.currentConnection?.remoteMonitoringClient(), self.taskInstance?.identifier != nil else
        {
            var errorMessage = "The task instance has no valid identifier."
            
            if (self.taskInstance?.identifier != nil)
            {
                errorMessage = "The remote monitoring client is nil."
            }
            
            self.showAlertWithError(error: nil, defaultMessage: "An error occurred while attempting to updated the action plan task - " + errorMessage, includeCancel: true, retryAction:nil)
            
            self.setStopHabitButtonEnabled(enabled: true)
            
            return
        }
        
        self.showWorking()
        
        // Delete the habit
        client.actionPlanTasksDelete(withActionPlanTaskId: (self.taskInstance?.identifier)!, completion:
            { (error) in
                
                guard error == nil else
                {
                    super.showAlertWithError(error: error,
                                             defaultMessage: "An unknown error occurred while stopping the action plan habit.",
                                             includeCancel: false,
                                             retryAction:
                        {
                            self.setStopHabitButtonEnabled(enabled: true)
                            self.hideWorking()
                    })
                    
                    return
                }
                
                self.updateObjective()
        })
    }
    
    private func updateObjective()
    {
        guard let client = HVConnection.currentConnection?.remoteMonitoringClient() else
        {
            self.showAlertWithError(error: nil, defaultMessage: "An error occurred while attempting to updated the action plan task - The remote monitoring client is nil.", includeCancel: true, retryAction:
                {
                    self.setStopHabitButtonEnabled(enabled: true)
                    self.hideWorking()
            })
            
            return
        }
        
        // Fetch the action plans (there should be at least be 1 action plan)
        client.actionPlansGet(completion:
            { (actionPlanInstance, error) in
                
                guard error == nil else
                {
                    super.showAlertWithError(error: error,
                                             defaultMessage: "An unknown error occurred while checking the status of action plans.",
                                             includeCancel: false,
                                             retryAction:
                        {
                            self.setStopHabitButtonEnabled(enabled: true)
                            self.hideWorking()
                    })

                    return
                }
                
                // Parse through the result to find the total number of active objectives and any objectives to delete.
                let result = self.objectivesToEnd(actionPlans: actionPlanInstance?.plans)
                
                let hasRemainingObjectives = result.objectivesCount > result.objectivesToEnd.count
                
                self.endObjectives(objectives: result.objectivesToEnd, hasRemainingObjectives:hasRemainingObjectives)
                
        })
    }
    
    // Retuns an array of all active objectives that have no tasks associated with them and the total count of all active objectives.
    // It is possible that a task is associated with multiple objectives, so if a task is deleted, we need a list of objectives that
    // have no tasks so they can be deleted.
    private func objectivesToEnd(actionPlans: [MHVActionPlanInstance]?) -> (objectivesToEnd: [MHVObjective], objectivesCount: Int)
    {
        var objectivesToEnd = Array<MHVObjective>()
        var count: Int = 0
        
        // Loop through all of the action plans in the collection.
        actionPlans?.forEach(
            { (actionPlan) in
            
                // Loop through all objectives in action plans.
                actionPlan.objectives.forEach(
                    { (objective) in
                    
                        // Only add objectives that are active.
                        if (objective.state == MHVObjectiveStateEnum.mhvInactive())
                        {
                            return
                        }
                        
                        // Add the objective to the objectivesToEnd array.
                        objectivesToEnd.append(objective)
                        
                        // Increment the total count of active objectives
                        count += 1
                        
                        // Loop through all associated tasks.
                        actionPlan.associatedTasks?.forEach(
                            { (task) in
                            
                                if (objectivesToEnd.count < 1)
                                {
                                    // The only objective in the objectivesToEnd array was removed in a previous iteration - break out of this loop.
                                    return
                                }
                                
                                // Loop through the tasks associated objective ids.
                                task.associatedObjectiveIds.forEach(
                                    { (objectiveId) in
                                        
                                        if (objective.identifier == objectiveId)
                                        {
                                            // Found a task associated with the given objective - Remove the objective from the objectivesToEnd array.
                                            if let index = objectivesToEnd.index(of: objective)
                                            {
                                                objectivesToEnd.remove(at: index)
                                            }
                                            
                                            return
                                        }
                                })
                        })
                })
        })
        
        return (objectivesToEnd, count)
    }
    
    // This method will call itself recursively by making a request to end the objective at the first index and passing the remaining
    // objectives in subsequent calls.
    private func endObjectives(objectives: [MHVObjective], hasRemainingObjectives: Bool)
    {
        if (objectives.count < 1)
        {
            // Post a notification that tasks have changed
            NotificationCenter.default.post(name: Constants.TasksChangedNotification, object: nil)
            
            if (hasRemainingObjectives)
            {
                self.navigateBack()
                return
            }
            
            self.navigateToCreatePlanViewController()
            return
        }
        
        var objectivesArray: [MHVObjective] = objectives
        let objective = objectivesArray.remove(at: 0)
        
        guard let client = HVConnection.currentConnection?.remoteMonitoringClient() else
        {
            self.showAlertWithError(error: nil, defaultMessage: "An error occurred while attempting to updated the action plan task - The remote monitoring client is nil.", includeCancel: true, retryAction:
                {
                    // This error may be impossible to recover from, so navigate back to the previous page.
                    self.navigateBack()
            })
            
            return
        }
        
        client.actionPlanObjectivesDelete(withActionPlanId: (self.taskInstance?.associatedPlanId)!, objectiveId: objective.identifier, completion:
            { (error) in
                
                guard error == nil else
                {
                    super.showAlertWithError(error: error,
                                             defaultMessage: "An unknown error occurred while ending the action plan objective.",
                                             includeCancel: false,
                                             retryAction:
                        {
                            // This error may be impossible to recover from, so navigate back to the previous page.
                            self.navigateBack()
                    })
                    
                    return
                }
                
                self.endObjectives(objectives: objectivesArray, hasRemainingObjectives: hasRemainingObjectives)
        })
    }
    
    private func sortSchedulesByTime()
    {
        if var schedules = self.taskInstance?.schedules
        {
            schedules.sort(by:
                { (schedule1, schedule2) -> Bool in
                    
                    if let date1 = schedule1.scheduledTime?.toDate()
                    {
                        if let date2 = schedule2.scheduledTime?.toDate()
                        {
                            return date1 < date2
                        }
                    }
                    
                return true
            })
            
            self.taskInstance?.schedules = schedules
        }
        
    }
    
    private func isFrequencyBasedTask() -> Bool
    {
        return self.taskInstance?.completionType == .mhvFrequency()
    }
    
    private func timesString() -> String?
    {
        var strings = ["Do this at these times:\n"]
        
        self.taskInstance?.schedules?.forEach(
            { (schedule) in
            
                if let dateString = self.formattedTimeString(date: schedule.scheduledTime?.toDate())
                {
                    if let daysString = self.daysString(schedule: schedule)
                    {
                        let string = dateString + "  |  " + daysString
                        strings.append(string)
                    }
                }
        })
        
        return strings.joined(separator: "\n")
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
                (!days.contains(.mhvSaturday()) ||
                    !days.contains(.mhvSunday())))
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
    
    // MARK: - Helpers
    
    private func setStopHabitButtonEnabled(enabled: Bool)
    {
        DispatchQueue.main.async
            {
                self.stopHabitButton.isEnabled = enabled;
        }
    }
    
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
    
    // MARK: - Actions
    
    @IBAction func stopHabitPressed(sender: UIButton)
    {
        let alert = UIAlertController.init(title: "Are you sure you want to stop this habit?",
                                           message: "This habit will be permanently removed.",
                                           preferredStyle: .alert)
        
        let alertActionCancel = UIAlertAction(title: "Cancel", style: .default, handler:nil)
        alert.addAction(alertActionCancel)
        
        let alertActionStop = UIAlertAction(title: "Stop", style: .destructive, handler:
        { (action) in
            
            self.setStopHabitButtonEnabled(enabled: false)
            self.stopHabit()
        })
        alert.addAction(alertActionStop)
        
        DispatchQueue.main.async
            {
                self.present(alert, animated: true, completion: nil)
        }
    }

    // MARK: - Navigation

    private func navigateToCreatePlanViewController()
    {
        // Refresh the plan status before navigating back
        let rootViewController = self.navigationController?.viewControllers[0] as! RootViewController
        rootViewController.checkPlanStatus()
        
        DispatchQueue.main.async
            {
                self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    private func navigateBack()
    {
        DispatchQueue.main.async
            {
                self.performSegue(withIdentifier: "UnwindToManageHabits", sender: self)
        }
    }
    
    @IBAction func prepareToUnwindFromEditHabit(segue: UIStoryboardSegue)
    {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let editHabitViewController = segue.destination as? EditHabitViewController
        {
            editHabitViewController.setTaskInstance(taskInstance: self.taskInstance)
        }
    }

}
