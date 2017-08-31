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

protocol ReminderManagerDataSource
{
    /// Return a set of UNNotificationCategory objects for the notifications
    func notificationCategories() -> Set<UNNotificationCategory>
    
    /// Retrieve tasks for scheduling reminders
    ///
    /// - Parameter completion: Envoke with the tasks or error
    ///             returning nil or an empty array to the completion handler with no error will remove all notifications
    func tasksForReminders(completion: @escaping ([MHVActionPlanTaskInstance]?, Error?) -> Void)
    
    /// Return the UNNotificationContent to use for a task, schedule for that task, and dayEnum for that schedule
    ///
    /// - Parameter task: The task for this notification content
    /// - Parameter schedule: The schedule in the task.schedules for this content
    /// - Parameter dayEnum: The dayEnum in the schedule for this content
    /// - Returns: The custom content
    func notificationContent(task: MHVActionPlanTaskInstance, schedule: MHVSchedule, dayEnum: MHVScheduleScheduledDaysEnum) -> UNNotificationContent?
}

