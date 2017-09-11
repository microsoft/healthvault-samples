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


import UIKit
import HealthVault

class TodayViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, TimelineTaskTableViewCellDelegate, RightBarButtonProtocol
{
    @IBOutlet var tableView: UITableView!
    
    var rightBarButtonSystemItem: UIBarButtonSystemItem? { get { return UIBarButtonSystemItem.add } }
    
    private var connection = HVConnection.currentConnection
    private var tableContents = [TimelineTaskCellData]()
    private var refreshControl: UIRefreshControl = UIRefreshControl()
    private var isLoading = false
    private var isLoadingLock = NSObject()
    
    func setConnection(connection: MHVSodaConnectionProtocol)
    {
        self.connection = connection
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.refreshControl.addTarget(self, action: #selector(refreshNow), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(self.refreshControl)
        
        self.tableView.contentInset = UIEdgeInsets.init(top: 28, left: 0, bottom: 28, right: 0)
        
        loadData(showWorkingIndicator: true)
        
        // Watch for notifications about tasks being tracked or changed to reload the timeline
        NotificationCenter.default.addObserver(self, selector: #selector(refreshNow), name: Constants.TaskTrackedNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshNow), name: Constants.TasksChangedNotification, object: nil)
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func refreshNow()
    {
        loadData(showWorkingIndicator: self.tableContents.count == 0)
    }
    
    @objc public func rightBarButtonAction()
    {
        navigateToTaskList()
    }
    
    // MARK: - HealthVault
    
    func loadData(showWorkingIndicator: Bool)
    {
        guard let remoteMonitoringClient = HVConnection.currentConnection?.remoteMonitoringClient() else
        {
            self.showAlertWithError(error: nil,
                                    defaultMessage: "Error loading timeline - The remote monitoring client is nil",
                                    includeCancel: false,
                                    retryAction: nil)
            return
        }
        
        // Avoid reloading if timeline refresh is already in progress
        objc_sync_enter(self.isLoadingLock)
        defer
        {
            objc_sync_exit(self.isLoadingLock)
        }
        if (isLoading)
        {
            return
        }
        isLoading = true
        
        var timelineTaskResult: MHVActionPlanTasksResponseTimelineTask_?
        var taskInstanceResult: MHVActionPlanTasksResponseActionPlanTaskInstance_?
        var loadingErrors = [Error]()
        let lockObject = NSObject()
        let loadingDispatchGroup = DispatchGroup()
        
        if (showWorkingIndicator)
        {
            showWorking()
        }
        
        // Load the timeline for the current time
        loadingDispatchGroup.enter()
        
        if let date = MHVLocalDate(date: Date()), let timeZone = date.timeZone()
        {
            remoteMonitoringClient.timelineGet(withTimeZone: timeZone,
                                               start: date,
                                               end: nil,
                                               planId: nil,
                                               objectiveId: nil,
                                               completion:
                { (timelineTasks, error) in
                    timelineTaskResult = timelineTasks
                    
                    if error != nil
                    {
                        objc_sync_enter(lockObject)
                        loadingErrors.append(error!)
                        objc_sync_exit(lockObject)
                    }
                    
                    loadingDispatchGroup.leave()
            })
        }
        else
        {
            print("Could not generate date and/or timezone.")
            loadingDispatchGroup.leave()
        }

        
        // In parallel with timeline, load all the action plan tasks
        loadingDispatchGroup.enter()
        remoteMonitoringClient.actionPlanTasksGet(withActionPlanTaskStatus: MHVPlanStatusEnum.mhvInProgress(),
                                                  completion:
            { (taskInstance: MHVActionPlanTasksResponseActionPlanTaskInstance_?, error: Error?) in
                
                taskInstanceResult = taskInstance
                
                if error != nil
                {
                    objc_sync_enter(lockObject)
                    loadingErrors.append(error!)
                    objc_sync_exit(lockObject)
                }
                
                loadingDispatchGroup.leave()
        })
        
        //Wait for tasks to complete, then process results
        loadingDispatchGroup.notify(queue: .global())
        {
            defer
            {
                objc_sync_enter(self.isLoadingLock)
                self.isLoading = false
                objc_sync_exit(self.isLoadingLock)
            }
            
            // Stop if any errors
            if loadingErrors.count > 0
            {
                self.loadCompleted(tableCells: nil, error: loadingErrors.first)
                return
            }
            
            let tableCells = self.processResults(timelineTaskResult: timelineTaskResult,
                                                 taskInstanceResult: taskInstanceResult)
            
            self.loadCompleted(tableCells: tableCells, error: nil)
        }
    }
    
    func trackTask(cellData: TimelineTaskCellData)
    {
        // Track the task for a table row's cell data
        guard let remoteMonitoringClient = HVConnection.currentConnection?.remoteMonitoringClient() else
        {
            self.showAlertWithError(error: nil,
                                    defaultMessage: "Error tracking task - The remote monitoring client is nil",
                                    includeCancel: false,
                                    retryAction: nil)
            return
        }
        
        cellData.isWorking = true
        self.reloadRow(taskId: cellData.taskId!)
        
        let occurrence = MHVTaskTrackingOccurrence()
        occurrence.taskId = cellData.taskId
        occurrence.trackingDateTime = MHVZonedDateTime()
        occurrence.trackingDateTime?.date = Date()
        
        remoteMonitoringClient.taskTrackingPost(with: occurrence, completion:
            { (number: MHVTaskTrackingOccurrence?, error: Error?) in
                
                defer
                {
                    cellData.isWorking = false
                    self.reloadRow(taskId: cellData.taskId!)
                }
                
                guard error == nil else
                {
                    self.showAlertWithError(error: error, defaultMessage: nil, includeCancel: false, retryAction: nil)
                    
                    return
                }
                
                // If the task was tracked within the completion window, the UI can update itself
                // If not, reload the timeline to get updated data to display
                if !cellData.updateIfTrackedTaskInWindow(date: (occurrence.trackingDateTime?.date)!)
                {
                    self.loadData(showWorkingIndicator: false)
                }
        })
    }
    
    func deleteTaskTracking(cellData: TimelineTaskCellData)
    {
        guard cellData.occurrenceCount == 1 && cellData.taskId != nil else
        {
            return
        }
        
        guard let remoteMonitoringClient = HVConnection.currentConnection?.remoteMonitoringClient() else
        {
            self.showAlertWithError(error: nil,
                                    defaultMessage: "Error tracking task - The remote monitoring client is nil",
                                    includeCancel: false,
                                    retryAction: nil)
            return
        }
        
        cellData.isWorking = true
        self.tableView.setEditing(false, animated: true)
        
        remoteMonitoringClient.taskTrackingDelete(withOccurrenceId: cellData.occurrenceIdentifiers.first!) {
            (_, error) in
            
            guard error == nil else
            {
                cellData.isWorking = false

                self.showAlertWithError(error: error,
                                        defaultMessage: "Error deleting task tracking",
                                        includeCancel: false,
                                        retryAction: nil)
                return
            }

            self.loadData(showWorkingIndicator: true)
        }
    }
    
    private func loadCompleted(tableCells: [TimelineTaskCellData]? ,error: Error?)
    {
        DispatchQueue.main.async
            {
                if error != nil
                {
                    self.tableContents = []
                    
                    self.showAlertWithError(error: error,
                                            defaultMessage: "Error loading timeline",
                                            includeCancel: true,
                                            retryAction:
                        {
                            self.loadData(showWorkingIndicator: true)
                    })
                }
                else
                {
                    self.tableContents = tableCells ?? []
                }
                
                self.hideWorking()
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
        }
    }
    
    //MARK: - Process results to generate timeline
    
    private func processResults(timelineTaskResult: MHVActionPlanTasksResponseTimelineTask_?,
                                taskInstanceResult: MHVActionPlanTasksResponseActionPlanTaskInstance_?) -> [TimelineTaskCellData]
    {
        var tableCells = [TimelineTaskCellData]()
        
        // Process timeline tasks to create cellData item for each table cell
        if let tasks = timelineTaskResult?.tasks
        {
            for task in tasks
            {
                tableCells.append(contentsOf: self.cellsForTimelineTask(task: task, date: Date()))
            }
        }
        
            tableCells.sort(by:
                { (cellData1, cellData2) -> Bool in
                    if let date1 = cellData1.sortDate, let date2 = cellData2.sortDate
                    {
                        return date1 < date2
                    }
                    else
                    {
                        return false
                    }
            })
        
        // Process tasks to add additional properties to table data
        if let tasks = taskInstanceResult?.tasks
        {
            tasks.forEach(
                { (task: MHVActionPlanTaskInstance) in
                    
                    for cellData in self.findCellsWithTaskId(cells: tableCells, taskId: task.identifier)
                    {
                        cellData.setTaskInstance(taskInstance: task)
                    }
            })
        }
        
        return tableCells
    }
    
    // Generate table cells for a task.
    private func cellsForTimelineTask(task: MHVTimelineTask, date: Date) -> [TimelineTaskCellData]
    {
        var cells = [TimelineTaskCellData]()
        
        // Get the in-window-occurrences for all schedules & occurrences for this task so they can be used below for filtering
        var occurrenceIdentifiers = inWindowOccurrenceIdentifiers(task: task)
        
        if let snapshot = task.timelineSnapshots?.first
        {
            // A Scheduled task without a schedule gets no cells
            if let completionType = snapshot.completionMetrics?.completionType,
                completionType == MHVTimelineSnapshotCompletionMetricsCompletionTypeEnum.mhvScheduled()
            {
                if snapshot.schedules == nil || snapshot.schedules?.count == 0
                {
                    return []
                }
            }
            
            // Any task with its date outside the snapshot's effective date range gets no cells
            if let startInstant = snapshot.effectiveStartInstant?.date,
                let endInstant = snapshot.effectiveEndInstant?.date
            {
                if date < startInstant || date > endInstant
                {
                    return []
                }
            }

            // Frequency tasks get one cell for all schedules
            if snapshot.completionMetrics?.completionType == MHVTimelineSnapshotCompletionMetricsCompletionTypeEnum.mhvFrequency()
            {
                cells.append(TimelineTaskCellData(task: task, schedules: snapshot.schedules!))
            }
            
            // Sheduled tasks add a cell for each schedule item
            // Each out-of-window occurrence for a schedule item adds a cell
            if let schedules = snapshot.schedules
            {
                for schedule in schedules
                {
                    if snapshot.completionMetrics?.completionType == MHVTimelineSnapshotCompletionMetricsCompletionTypeEnum.mhvScheduled()
                    {
                        // Scheduled tasks get one cell per schedule item
                        cells.append(TimelineTaskCellData(task: task, schedules: [schedule]))
                        
                        // Plus cells for out-of-window occurrences
                        if let occurrences = schedule.occurrences
                        {
                            // Check for adding a cell for each out-of-window occurrence
                            for occurrence in occurrences
                            {
                                if let occurrenceDate = occurrence.localDateTime?.date,
                                    let inWindow = occurrence.inWindow,
                                    let identifier = occurrence.identifier,
                                    inWindow.boolValue == false
                                {
                                    // Include out-of-window occurrences that are not found in the occurrenceIdentifiers
                                    // On a task with multiple schedules, 8:00AM and 5:00PM, tracking at 8:00AM would give an in-window
                                    // occurrence for the 8am, but also an out-of-window occurrence for the 5pm.
                                    if !occurrenceIdentifiers.contains(identifier)
                                    {
                                        let newSchedule = schedule.copy() as! MHVTimelineSchedule
                                        newSchedule.occurrences = [occurrence]
                                        
                                        // Out-of-window occurrences are set to 1 required occurrences, so doesn't show "X/Y" UI & get checkmark
                                        let newTask = task.copy() as! MHVTimelineTask
                                        if let _ = newTask.timelineSnapshots?.first?.completionMetrics?.requiredNumberOfOccurrences
                                        {
                                            newTask.timelineSnapshots?.first?.completionMetrics?.requiredNumberOfOccurrences = 1
                                        }
                                        
                                        let cell = TimelineTaskCellData(task: newTask, schedules: [schedule])
                                        
                                        cell.setOutOfWindowOccurrence(occurrenceDate, identifier: identifier)
                                        cells.append(cell)
                                        
                                        // Add to the array, so logging a task at 1:00PM for the 8:00AM and 5:00PM example
                                        // only shows one out-of-window occurrence in the UI & not for both
                                        occurrenceIdentifiers.append(identifier)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            // Add Unscheduled Occurrences
            if let unscheduledOccurrences = snapshot.unscheduledOccurrences
            {
                for unscheduledOccurrence in unscheduledOccurrences
                {
                    if let occurrenceDate = unscheduledOccurrence.localDateTime?.date,
                       let identifier = unscheduledOccurrence.identifier,
                       !occurrenceIdentifiers.contains(identifier)
                    {
                        // Out-of-window occurrences are set to 1 required occurrences, so doesn't show "X/Y" UI & get checkmark
                        let newTask = task.copy() as! MHVTimelineTask
                        if let _ = newTask.timelineSnapshots?.first?.completionMetrics?.requiredNumberOfOccurrences
                        {
                            newTask.timelineSnapshots?.first?.completionMetrics?.requiredNumberOfOccurrences = 1
                        }

                        let cell = TimelineTaskCellData(task: newTask, schedules: [])
                        
                        cell.setOutOfWindowOccurrence(occurrenceDate, identifier: identifier)
                        cells.append(cell)
                        
                        // Add to the array, so logging a task at 1:00PM for the 8:00AM and 5:00PM example
                        // only shows one out-of-window occurrence in the UI & not for both
                        occurrenceIdentifiers.append(identifier)
                    }
                }
            }
        }
        
        return cells
    }
    
    // Build an array of the identifiers for all the in-window-occurrences for a task
    private func inWindowOccurrenceIdentifiers(task: MHVTimelineTask) -> [String]
    {
        var identifiers = [String]()
        
        // First, find identifiers for all in-window-occurrences
        if let snapshot = task.timelineSnapshots?.first
        {
            if let schedules = snapshot.schedules
            {
                for schedule in schedules
                {
                    if let occurrences = schedule.occurrences
                    {
                        for occurrence in occurrences
                        {
                            if let inWindow = occurrence.inWindow,
                                let identifier = occurrence.identifier,
                                inWindow.boolValue
                            {
                                identifiers.append(identifier)
                            }
                        }
                    }
                }
            }
        }
        
        return identifiers
    }
    
    // MARK: - Table View Delegate & DataSource
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return tableContents.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView .dequeueReusableCell(withIdentifier: "TimelineTaskTableViewCell", for: indexPath) as! TimelineTaskTableViewCell
        
        cell.setupCell(taskData: tableContents[indexPath.row],
                       delegate: self)
        
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.navigateToTrackTask(cellData: tableContents[indexPath.row])
    }
    
    internal func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return tableContents[indexPath.row].occurrenceIdentifiers.count == 1
    }
    
    internal func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        self.deleteTaskTracking(cellData: tableContents[indexPath.row])
    }
    
    internal func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?
    {
        return "Undo"
    }
    
    private func reloadRow(taskId: String)
    {
        for (index, cellData) in tableContents.enumerated()
        {
            if cellData.taskId == taskId
            {
                DispatchQueue.main.async
                    {
                        self.tableView.reloadRows(at: [IndexPath.init(row: index, section: 0)], with: .none)
                }
                return
            }
        }
    }

    private func findCellsWithTaskId(cells: [TimelineTaskCellData], taskId: String?) -> [TimelineTaskCellData]
    {
        var cellsWithTaskId = [TimelineTaskCellData]()
        
        guard taskId != nil else
        {
            return cellsWithTaskId
        }
        
        for cellData in cells
        {
            if cellData.taskId == taskId!
            {
                cellsWithTaskId.append(cellData)
            }
        }
        return cellsWithTaskId
    }
    
    // MARK: - Navigation
    
    @objc func navigateToTaskList()
    {
        DispatchQueue.main.async
            {
                self.performSegue(withIdentifier: "NavigateToTaskListViewController", sender: nil)
        }
    }
    
    func navigateToTrackTask(cellData: TimelineTaskCellData)
    {
        // Called from TimelineTaskTableViewCellDelegate
        DispatchQueue.main.async
            {
                self.performSegue(withIdentifier: "NavigateToTrackTaskViewController", sender: cellData)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if sender is UIBarButtonItem || sender == nil
        {
        }
        else
        {
            guard let cellData = sender as! TimelineTaskCellData? else
            {
                print("Expected task data")
                return
            }
            
            // Pass data to view controller that is appearing
            if segue.destination is TrackTaskViewController
            {
                let vc = segue.destination as! TrackTaskViewController
                vc.setCellData(cellData: cellData)
            }
        }
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue)
    {
        //Unwinding to here means a task was logged, reload timeline
        loadData(showWorkingIndicator: true)
    }
    
}
