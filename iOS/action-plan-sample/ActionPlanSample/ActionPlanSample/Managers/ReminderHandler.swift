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
    private let logNowActionIdentifier = "LogNow"
    private let categoryIdentifier = "Reminder"
    
    //MARK: - ReminderManagerDataSource
    
    /// Return a set of UNNotificationCategory objects for the notifications
    func notificationCategories() -> Set<UNNotificationCategory>
    {
        let logNow = UNNotificationAction.init(identifier: self.logNowActionIdentifier,
                                               title: "Log Now",
                                               options: [])
        
        // Add reminder notification category, with "Log" button actions
        let category = UNNotificationCategory(identifier: self.categoryIdentifier,
                                              actions: [logNow],
                                              intentIdentifiers: [],
                                              options: [])
        
        return [category]
    }
    
    /// Generate an array of UNNotificationContent based on reminderItems.
    /// If 1 reminder, it is shown with the task name; if > 1 then they are merged into one
    ///
    /// - Parameter reminderItems: Array of structs with details about the task reminders
    /// - Returns: The custom content for notifications based on the reminders.
    /// - Note: The UNNotificationContent.userInfo dictionaries must contain a value for the ReminderManager.reminderIdentifierKey key
    func notificationContent(reminderItems: [ReminderItem]) -> [UNNotificationContent]?
    {
        if reminderItems.count == 0
        {
            return nil
        }
        
        // If only one reminder
        if reminderItems.count == 1
        {
            if let content = notificationContent(reminderItem: reminderItems.first!)
            {
                return [content]
            }
            return nil
        }
        
        // Multiple reminders at the same time.
        // Create identifier by combining all the identifiers
        let taskIdentifiers = reminderItems.map({ $0.identifier }).joined(separator: ",")
        
        // Create content to show the count of tasks
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "You have \(reminderItems.count) tasks"
        content.sound = UNNotificationSound.default()
        
        content.userInfo = [ReminderManager.reminderIdentifierKey : taskIdentifiers]
        
        return [content]
    }
    
    /// Return the UNNotificationContent to use when only one reminder is needed for a day/time
    ///
    /// - Parameter reminderItem: Struct with details about the reminder that will be shown
    /// - Returns: The custom content
    private func notificationContent(reminderItem: ReminderItem) -> UNNotificationContent?
    {
        // For 1 task, it shows the name and can be logged
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = reminderItem.task.name
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = self.categoryIdentifier
        
        content.userInfo = [ReminderManager.reminderIdentifierKey : reminderItem.identifier,
                            self.taskIdKey : reminderItem.taskIdentifier,
                            self.hourKey : reminderItem.scheduledTime.hour,
                            self.minuteKey : reminderItem.scheduledTime.minute]
        
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
    private func trackTask(_ taskId: String, date: Date, completion: @escaping () -> Void)
    {
        guard let remoteMonitoringClient = HVConnection.currentConnection?.remoteMonitoringClient() else
        {
            self.showAlertWithError(error: nil, defaultMessage: "HealthVault connection is not set")
            completion()
            return
        }
        
        let occurrence = MHVTaskTrackingOccurrence()
        occurrence.taskId = taskId
        occurrence.trackingDateTime = MHVZonedDateTime.init(date: date)
        
        remoteMonitoringClient.taskTrackingPost(with: occurrence, completion:
            { (number: MHVTaskTrackingOccurrence?, error: Error?) in
                
                defer
                {
                    completion()
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
                self.trackTask(taskId, date: Date(), completion: completionHandler)
                return
            }
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
