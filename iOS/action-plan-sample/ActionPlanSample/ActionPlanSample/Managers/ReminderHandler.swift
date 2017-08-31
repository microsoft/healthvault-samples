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
import UserNotifications

class ReminderHandler: NSObject, ReminderManagerDataSource, UNUserNotificationCenterDelegate
{
    /// Shared ReminderHandler instance to use
    static let shared = ReminderHandler()

    private let taskIdKey = "taskId"
    private let hourKey = "hour"
    private let minuteKey = "minute"
    private let logOnTimeActionIdentifier = "LogOnTime"
    private let logNowActionIdentifier = "LogNow"
    private let categoryIdentifier = "Reminder"
    
    //MARK: - ReminderManagerDataSource
    
    /// Return a set of UNNotificationCategory objects for the notifications
    func notificationCategories() -> Set<UNNotificationCategory>
    {
        let logNow = UNNotificationAction.init(identifier: self.logNowActionIdentifier,
                                               title: "Log Now",
                                               options: [])
        let logOnTime = UNNotificationAction.init(identifier: self.logOnTimeActionIdentifier,
                                                  title: "Log On Time",
                                                  options: [])
        
        // Add reminder notification category, with "Log" button actions
        let category = UNNotificationCategory(identifier: self.categoryIdentifier,
                                              actions: [logNow, logOnTime],
                                              intentIdentifiers: [],
                                              options: [])
        
        return [category]
    }
    
    /// Return the UNNotificationContent to use for a task, schedule for that task, and dayEnum for that schedule
    func notificationContent(task: MHVActionPlanTaskInstance, schedule: MHVSchedule, dayEnum: MHVScheduleScheduledDaysEnum) -> UNNotificationContent?
    {
        guard let taskIdentifier = task.identifier,
            let scheduledTime = schedule.scheduledTime else
        {
            return nil
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = task.name
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = self.categoryIdentifier
        
        content.userInfo = [self.taskIdKey : taskIdentifier,
                            self.hourKey : scheduledTime.hour,
                            self.minuteKey : scheduledTime.minute]

        return content
    }
    
    //MARK: - HealthVault
    
    /// Retrieve and return the tasks that should have reminders
    func tasksForReminders(completion: @escaping ([MHVActionPlanTaskInstance]?, Error?) -> Void)
    {
        guard let remoteMonitoringClient = HVConnection.currentConnection?.remoteMonitoringClient() else
        {
            self.showAlertWithError(error: nil, defaultMessage: "HealthVault connection is not set")
            completion(nil, HealthVaultError.noHealthVaultConnection)
            return
        }
        
        remoteMonitoringClient.actionPlanTasksGet(withActionPlanTaskStatus: MHVPlanStatusEnum.mhvInProgress(),
                                                  completion:
            { (taskInstance: MHVActionPlanTasksResponseActionPlanTaskInstance_?, error: Error?) in
                
                // Schedule reminders for the tasks
                if let tasks = taskInstance?.tasks
                {
                    // NOTE: Apps may want to filter tasks for only plans they have created, etc.
                    completion(tasks, nil)
                }
                else
                {
                    completion(nil, error)
                }
        })
    }
    
    /// Track a task occurrence
    ///
    /// - Parameter taskId: The identifier of the task
    /// - Parameter date: The time to use for tracking
    private func trackTask(_ taskId: String, date: Date)
    {
        guard let remoteMonitoringClient = HVConnection.currentConnection?.remoteMonitoringClient() else
        {
            self.showAlertWithError(error: nil, defaultMessage: "HealthVault connection is not set")
            return
        }
        
        var backgroundTask = UIBackgroundTaskInvalid
        backgroundTask = UIApplication.shared.beginBackgroundTask
            {
                // End if background task is expiring
                print("TrackTask timed out")
                UIApplication.shared.endBackgroundTask(backgroundTask)
        }
        
        let occurrence = MHVTaskTrackingOccurrence()
        occurrence.taskId = taskId
        occurrence.trackingDateTime = MHVZonedDateTime.init(date: date)
        
        remoteMonitoringClient.taskTrackingPost(with: occurrence, completion:
            { (number: MHVTaskTrackingOccurrence?, error: Error?) in
                
                defer
                {
                    UIApplication.shared.endBackgroundTask(backgroundTask)
                }
                
                guard error == nil else
                {
                    self.showAlertWithError(error: error, defaultMessage: "Error logging the task")
                    return
                }
                
                print("Tracked Task for \(taskId)")

                NotificationCenter.default.post(name: Constants.TaskTrackedNotification, object: taskId)
        })
    }
    
    // MARK: - UNUserNotificationCenterDelegate
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       willPresent notification: UNNotification,
                                       withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void)
    {
        completionHandler([.alert, .badge, .sound])
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       didReceive response: UNNotificationResponse,
                                       withCompletionHandler completionHandler: @escaping () -> Void)
    {
        if let taskId = response.notification.request.content.userInfo[self.taskIdKey] as? String
        {
            print("Received Notification Action Identifier \(response.actionIdentifier)")

            if response.actionIdentifier == logNowActionIdentifier
            {
                // Log Now
                self.trackTask(taskId, date: Date())
            }
            else if response.actionIdentifier == logOnTimeActionIdentifier
            {
                // Log On Time, use hour/minute from task with the date of the notification they are responding
                // So "Log On Time" for a reminder shown yesterday will log for yesterday's date
                if let hour = response.notification.request.content.userInfo[self.hourKey] as? Int,
                    let minute = response.notification.request.content.userInfo[self.minuteKey] as? Int
                {
                    var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .timeZone],
                                                                         from: response.notification.date)
                    dateComponents.hour = hour
                    dateComponents.minute = minute
                    
                    if let trackDate = Calendar.current.date(from: dateComponents)
                    {
                        self.trackTask(taskId, date: trackDate)
                    }
                    else
                    {
                        self.showAlertWithError(error: nil, defaultMessage: "Time to track the task could not be calculated")
                    }
                }
                else
                {
                    self.showAlertWithError(error: nil, defaultMessage: "Time to track the task was not set")
                }
            }
        }
        else
        {
            self.showAlertWithError(error: nil, defaultMessage: "TaskId was not found on the notification response")
        }
        
        completionHandler()
    }
    
    // MARK: - Error Alert
    
    func showAlertWithError(error: Error?,
                            defaultMessage: String)
    {
        print("Error alert: \(defaultMessage)")

        var message = error?.localizedDescription
        
        if (message == nil)
        {
            message = defaultMessage
        }

        // show error and/or retry
        let alert = UIAlertController.init(title: "Action Plan Error",
                                           message: message,
                                           preferredStyle: .alert)
        
        let alertActionOK = UIAlertAction(title: "OK", style: .default, handler:nil)
        alert.addAction(alertActionOK)
    
        // If app is in the background, UIAlertController will not be visible until app is opened; schedule a reminder so the error appears now
        if UIApplication.shared.applicationState == .background
        {
            ReminderManagerFactory.reminderManager()?.showErrorNotification(title: "Action Plan Error",
                                                                            message: "\(message!)\n\nPlease open app to retry")
        }
        else
        {
            DispatchQueue.main.async
                {
                    if let rootViewController = UIApplication.shared.keyWindow?.rootViewController
                    {
                        rootViewController.present(alert, animated: true, completion: nil)
                    }
            }
        }
    }
}
