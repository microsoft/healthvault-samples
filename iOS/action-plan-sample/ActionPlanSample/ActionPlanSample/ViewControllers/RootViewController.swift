//
//  RootViewController.swift
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

import Foundation
import HealthVault

class RootViewController : BaseViewController
{
    private static let objectiveId = "1c71ced0-3f55-4a66-a8c9-189836304bb1"
    
    private let noMoreCaffieneTaskKey = "cd6a9a3f-1746-4b7d-8bad-4e988a0978fd"
    private let windDownForBedTaskKey = "f7d40787-e018-441e-b9ed-93a42f9a1c80"
    private let consistentBedtimeTaskKey = "69df998a-854c-43a1-8655-e37a33127d9e"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let signOutButton = UIBarButtonItem(title: "Sign out", style: .plain, target: self, action: #selector(signOutButtonPressed))
        
        self.navigationItem.leftBarButtonItem = signOutButton
        
        self.checkPlanStatus()
    }
    
    // MARK: HealthVault
    
    public func checkPlanStatus()
    {
        self.showWorking()
    
        // Ensure that the connection is not nil
        guard HVConnection.currentConnection != nil else
        {
            self.showAlertWithError(error: nil);
            return
        }
        
        // Authenticate the connection - If the user is not logged in this call will present the login flow from this view controller.
        HVConnection.currentConnection?.authenticate(with: self, completion:
            {(_ error: Error?) in
                
                guard error == nil else
                {
                    self.showAlertWithError(error: error)
                    return
                }
                
                guard let client = HVConnection.currentConnection?.remoteMonitoringClient() else
                {
                    self.showAlertWithError(error: nil);
                    return
                }
                
                // Check if the user has any action plans.
                client.actionPlansGet(completion:
                    { (actionPlanInstance, error) in
                        
                        guard error == nil else
                        {
                            self.showAlertWithError(error: error)
                            return
                        }
                        
                        if ((actionPlanInstance?.plans?.count)! > 0)
                        {
                            // The user has an action plan - Start reminder manager and Navigate to the tab bar view controller.
                            self.startReminderManager()
                            self.navigateToActionPlan()
                        }
                        else
                        {
                            // The user does not have an action plan - Dismiss the loading view and show the option to create a new plan.
                            self.hideWorking()
                        }
                })
        })
    }
    
    private func generateNewPlan() -> (MHVActionPlan)
    {
        let newActionPlan = MHVActionPlan();
        newActionPlan.name = "Sleep"
        newActionPlan.imageUrl = "https://img-prod-cms-rt-microsoft-com.akamaized.net/cms/api/am/imageFileData/REYD7m?ver=7ea4"
        newActionPlan.thumbnailImageUrl = "https://img-prod-cms-rt-microsoft-com.akamaized.net/cms/api/am/imageFileData/REYD7d?ver=6bf1"
        newActionPlan.category = MHVActionPlanCategoryEnum.mhvSleep()
        newActionPlan.objectives = [self.actionPlanObjective()]
        newActionPlan.associatedTasks = [self.noMoreCaffeineTask(), self.windDownForBedTask(), self.consistentBedtimeTask()]
        
        return newActionPlan;
    }
    
    // Generates a new objective object for the 'Get more sleep' plan
    private func actionPlanObjective() -> MHVObjective
    {
        let objective = MHVObjective()
        objective.identifier = RootViewController.objectiveId
        objective.name = "Get more sleep"
        objective.descriptionText = "Work on habits that help you maximize how much you sleep."
        objective.state = MHVObjectiveStateEnum.mhvActive()
        objective.outcomeType = MHVObjectiveOutcomeTypeEnum.mhvSleepHoursPerNight()
        objective.outcomeName = "Hours asleep / night"
    
        return objective
    }
    
    private func noMoreCaffeineTask() -> MHVActionPlanTask
    {
        // Create a new MHVActionPlanTask object
        let noMoreCaffeineTask = self.newTask()
        
        // Set the name and description properties
        noMoreCaffeineTask.name = "Cut the caffeine"
        noMoreCaffeineTask.signupName = "Limit caffeine before bedtime"
        noMoreCaffeineTask.shortDescription = "Caffeine is a stimulant. Avoid it close to bedtime."
        noMoreCaffeineTask.longDescription = "Consuming caffeine late in the day can disrupt sleep. Avoid caffeine within 8 hours of bedtime."
        
        // Add image URLS
        noMoreCaffeineTask.imageUrl = "https://img-prod-cms-rt-microsoft-com.akamaized.net/cms/api/am/imageFileData/REYq6U?ver=19ee"
        noMoreCaffeineTask.thumbnailImageUrl = "https://img-prod-cms-rt-microsoft-com.akamaized.net/cms/api/am/imageFileData/REYD7e?ver=2c7d"
        
        // Set how many times per day the task should be completed
        noMoreCaffeineTask.frequencyTaskCompletionMetrics = self.newDailyTaskCompletionMetrics(occurenceCount: 1)
        
        // Set the time the task should be completed
        noMoreCaffeineTask.schedules = [self.newEveryDaySchedule(hours: 14, minutes: 0, shouldRemind: false)]
        
        // Set the taskKey to uniquely identify this task across all users
        noMoreCaffeineTask.taskKey = noMoreCaffieneTaskKey
        
        return noMoreCaffeineTask
    }
    
    private func windDownForBedTask() -> MHVActionPlanTask
    {
        // Create a new MHVActionPlanTask object
        let windDownForBedTask = self.newTask()
        
        // Set the name and description properties
        windDownForBedTask.name = "Wind down for bed"
        windDownForBedTask.signupName = "Wind down for bed"
        windDownForBedTask.shortDescription = "Take some time to relax before bed. This will help you transition to sleep."
        windDownForBedTask.longDescription = "Engage in calming activity the hour before bed to transition to sleep mode. Dim the lights and avoid electronic screens."
        
        // Add image URLS
        windDownForBedTask.imageUrl = "https://img-prod-cms-rt-microsoft-com.akamaized.net/cms/api/am/imageFileData/REYD7m?ver=7ea4"
        windDownForBedTask.thumbnailImageUrl = "https://img-prod-cms-rt-microsoft-com.akamaized.net/cms/api/am/imageFileData/REYD7d?ver=6bf1"
        
        // Set how many times per day the task should be completed
        windDownForBedTask.frequencyTaskCompletionMetrics = self.newWeeklyTaskCompletionMetrics(occurenceCount: 7)
        
        // Set the time the task should be completed
        windDownForBedTask.schedules = [self.newEveryDaySchedule(hours: 21, minutes: 30, shouldRemind: true)]
        
        // Set the taskKey to uniquely identify this task across all users
        windDownForBedTask.taskKey = windDownForBedTaskKey
        
        return windDownForBedTask
    }
    
    private func consistentBedtimeTask() -> MHVActionPlanTask
    {
        // Create a new MHVActionPlanTask object
        let consistentBedtimeTask = self.newTask()
        
        // Set the name and description properties
        consistentBedtimeTask.name = "Consistent bedtime"
        consistentBedtimeTask.signupName = "Set a consistent bedtime"
        consistentBedtimeTask.shortDescription = "Set a consistent bed time to help regulate your body's internal clock."
        consistentBedtimeTask.longDescription = "Schedule a bedtime that allows you to get sufficient sleep time (ideally 7 to 9 hours). Studies show that going to bed at a consistent time every night, even on weekends, is one of the best ways to ensure a good night's sleep."
        
        // Add image URLS
        consistentBedtimeTask.imageUrl = "https://img-prod-cms-rt-microsoft-com.akamaized.net/cms/api/am/imageFileData/REYAwK?ver=4ad0"
        consistentBedtimeTask.thumbnailImageUrl = "https://img-prod-cms-rt-microsoft-com.akamaized.net/cms/api/am/imageFileData/REYxUB?ver=b00b"
        
        
        // Set how many times per day the task should be completed
        consistentBedtimeTask.frequencyTaskCompletionMetrics = self.newDailyTaskCompletionMetrics(occurenceCount: 1)
        
        // Set the time the task should be completed
        consistentBedtimeTask.schedules = [self.newEveryDaySchedule(hours: 22, minutes: 0, shouldRemind: true)]
        
        // Set the taskKey to uniquely identify this task across all users
        consistentBedtimeTask.taskKey = consistentBedtimeTaskKey
        
        return consistentBedtimeTask
    }
    
    // Generates a new task object. All tasks in the test plan will be 'non-blood pressure', completion type 'frequency', and manually tracked
    private func newTask() -> MHVActionPlanTask
    {
        // Create a new MHVActionPlanTask object
        let task = MHVActionPlanTask()
        
        // Set the task type (either a blood pressure task or other)
        task.taskType = MHVActionPlanTaskTaskTypeEnum.mhvOther()
        
        // Set up the completion type
        task.completionType = MHVActionPlanTaskCompletionTypeEnum.mhvFrequency()
        
        // Set up the tracking policy
        task.trackingPolicy = MHVActionPlanTrackingPolicy()
        task.trackingPolicy.isAutoTrackable = false
        
        // Associate the task with the objective
        task.associatedObjectiveIds = [RootViewController.objectiveId]
        
        return task
    }
    
    // Generates a new MHVActionPlanFrequencyTaskCompletionMetrics object with the given number of occurences per day
    private func newDailyTaskCompletionMetrics(occurenceCount: NSNumber) -> MHVActionPlanFrequencyTaskCompletionMetrics
    {
        let dailyTaskCompletionMetrics = MHVActionPlanFrequencyTaskCompletionMetrics()
        dailyTaskCompletionMetrics.windowType = MHVActionPlanFrequencyTaskCompletionMetricsWindowTypeEnum.mhvDaily()
        dailyTaskCompletionMetrics.occurrenceCount = occurenceCount
        
        return dailyTaskCompletionMetrics;
    }

    // Generates a new MHVActionPlanFrequencyTaskCompletionMetrics object with the given number of occurences per week
    func newWeeklyTaskCompletionMetrics(occurenceCount: NSNumber) -> MHVActionPlanFrequencyTaskCompletionMetrics
    {
        let dailyTaskCompletionMetrics = MHVActionPlanFrequencyTaskCompletionMetrics()
        dailyTaskCompletionMetrics.windowType = MHVActionPlanFrequencyTaskCompletionMetricsWindowTypeEnum.mhvWeekly()
        dailyTaskCompletionMetrics.occurrenceCount = occurenceCount
        
        return dailyTaskCompletionMetrics;
    }

    // Generates a new MHVSchedule object for a task that should occur daily
    private func newEveryDaySchedule(hours: Int32, minutes: Int32, shouldRemind: Bool) -> MHVSchedule
    {
        // Set up the schedule and add reminders.
        let schedule = MHVSchedule()
        if (shouldRemind)
        {
            schedule.reminderState = MHVScheduleReminderStateEnum.mhvOnTime()
        }
        else
        {
            schedule.reminderState = MHVScheduleReminderStateEnum.mhvOff()
        }

        schedule.scheduledDays = [MHVScheduleScheduledDaysEnum.mhvEveryday()]
        schedule.scheduledTime = MHVTime()
        schedule.scheduledTime?.hour = hours
        schedule.scheduledTime?.minute = minutes
        
        return schedule
    }
    

    
    // MARK: Actions
    
    @IBAction func generateSampleButtonPressed(sender: UIButton)
    {
     
        let newActionPlan = self.generateNewPlan()
        
        HVConnection.currentConnection?.remoteMonitoringClient()?.actionPlansCreate(with: newActionPlan, completion:
            { (actionPlanInstance, error) in
                
                guard error == nil else
                {
                    self.showAlertWithError(error: error)
                    return
                }
                
                self.startReminderManager()
                self.navigateToActionPlan()
        })
    }
    
    func signOutButtonPressed()
    {
        HVConnection.signOut(presentingViewController: self, completion:
            {
                self.checkPlanStatus()
        })
    }
    
    // MARK: Reminders
    
    private func startReminderManager()
    {
        // Ask for permission to show notifications
        ReminderManagerFactory.reminderManager()?.requestAuthorization
            { (isAuthorized) in
        }
    }
    
    // MARK: Navigation
    
    private func navigateToActionPlan()
    {
        DispatchQueue.main.async
            {
                self.navigationController?.pushViewController(TabBarViewController(), animated: false)
        }
    }
    
    // MARK: Errors
    
    private func showAlertWithError(error: Error?)
    {
        super.showAlertWithError(error: error,
                                 defaultMessage: "An unknown error occcured while checking the status of the action plan.",
                                 includeCancel: false,
                                 retryAction:
            {
                self.checkPlanStatus()
        })
    }
    
}


