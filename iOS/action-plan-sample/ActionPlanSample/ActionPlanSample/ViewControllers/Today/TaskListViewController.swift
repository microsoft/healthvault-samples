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

class TaskListViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet var tableView: UITableView!
    
    private var tableContents = [MHVActionPlanTaskInstance]()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        loadData(showWorkingIndicator: true)

        self.tableView.contentInset = UIEdgeInsets.init(top: 28, left: 0, bottom: 28, right: 0)
    }

    // MARK: - HealthVault
    
    private func loadData(showWorkingIndicator: Bool)
    {
        guard let remoteMonitoringClient = HVConnection.currentConnection?.remoteMonitoringClient() else
        {
            self.showAlertWithError(error: nil,
                                    defaultMessage: "Error loading tasks - The remote monitoring client is nil",
                                    includeCancel: false,
                                    retryAction: nil)
            return
        }

        if (showWorkingIndicator)
        {
            showWorking()
        }
        
        remoteMonitoringClient.actionPlanTasksGet(withActionPlanTaskStatus: MHVPlanStatusEnum.mhvInProgress(),
                                                  completion:
            { (taskInstance, error) in
                
                DispatchQueue.main.async
                    {
                        if error != nil
                        {
                            self.tableContents = []
                            
                            self.showAlertWithError(error: error,
                                                    defaultMessage: "Error loading tasks",
                                                    includeCancel: true,
                                                    retryAction:
                                {
                                    self.loadData(showWorkingIndicator: true)
                            })
                        }
                        else
                        {
                            self.tableContents = taskInstance?.tasks ?? []
                        }
                        
                        self.hideWorking()
                        self.tableView.reloadData()
                }
        })
    }
    
    private func trackTask(taskId: String)
    {
        guard let remoteMonitoringClient = HVConnection.currentConnection?.remoteMonitoringClient() else
        {
            self.showAlertWithError(error: nil,
                                    defaultMessage: "Error tracking task - The remote monitoring client is nil",
                                    includeCancel: false,
                                    retryAction: nil)
            return
        }

        let occurrence = MHVTaskTrackingOccurrence()
        occurrence.taskId = taskId
        occurrence.trackingDateTime = MHVZonedDateTime()
        occurrence.trackingDateTime?.date = Date()

        self.showWorking()
        
        remoteMonitoringClient.taskTrackingPost(with: occurrence, completion:
            { (number: MHVTaskTrackingOccurrence?, error: Error?) in
                
                guard error == nil else
                {
                    self.hideWorking()
                    self.showAlertWithError(error: error, defaultMessage: nil, includeCancel: false, retryAction: nil)
                    return
                }
          
                NotificationCenter.default.post(name: Constants.TaskTrackedNotification, object: taskId)
                
                self.navigateBackTaskLogged()
        })
    }
    
    // MARK: - Table View Delegate & DataSource
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return tableContents.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView .dequeueReusableCell(withIdentifier: "TaskListTableViewCell", for: indexPath) as! TaskListTableViewCell
        
        cell.updateCell(task: tableContents[indexPath.row])
        
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        navigateToTrackTask(task: tableContents[indexPath.row])
    }
    
    // MARK: - Navigation

    private func navigateToTrackTask(task: MHVActionPlanTaskInstance)
    {
        DispatchQueue.main.async
            {
                self.performSegue(withIdentifier: "NavigateToTrackTaskViewControllerFromTaskList", sender: task)
        }
    }

    private func navigateBackTaskLogged()
    {
        DispatchQueue.main.async
            {
                self.performSegue(withIdentifier: "taskWasLogged", sender: self)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is TrackTaskViewController
        {
            guard let taskInstance = sender as! MHVActionPlanTaskInstance? else
            {
                print("Expected task data")
                return
            }
            
            let vc = segue.destination as! TrackTaskViewController
            vc.setTaskInstance(taskInstance: taskInstance)
        }
    }
}
