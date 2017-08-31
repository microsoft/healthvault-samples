//
//  ManageHabitsViewController.swift
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
import UIKit
import HealthVault

class ManageHabitsViewContoller: BaseViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet var tableView: UITableView!
    
    private var refreshControl = UIRefreshControl()
    private var tableData = Array<Array<Any>>()
    private var actionPlanDictionary = Dictionary<String, MHVActionPlanInstance>()
    private var didDeferUpdate = false
    
    init()
    {
        super.init(nibName: nil, bundle: nil)
        
        self.loadActionPlans(shouldShowWorking: true)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        self.loadActionPlans(shouldShowWorking: true)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(self.refreshControl)
        self.tableView.contentInset = UIEdgeInsetsMake(-44, 0, 0, 0)
        
        if (self.didDeferUpdate)
        {
            self.updateView()
        }
    }
    
    func refresh()
    {
        loadActionPlans(shouldShowWorking: false)
    }
    
    // MARK: - HealthVault
    private func loadActionPlans(shouldShowWorking: Bool)
    {
        guard let client = HVConnection.currentConnection?.remoteMonitoringClient() else
        {
            self.showAlertWithError(error: nil, defaultMessage: "An error occurred while attempting to updated the action plan task - The remote monitoring client is nil.", includeCancel: true, retryAction:nil)
            
            self.hideWorking()
            
            return
        }
        
        if (shouldShowWorking)
        {
            self.showWorking()
        }

        client.actionPlansGet(completion:
            { (actionPlanInstance, error) in
            
                guard error == nil else
                {
                    self.showAlertWithError(error: nil, defaultMessage: "An error has occurred fetching Action Plans.", includeCancel: false, retryAction:
                        {
                            self.loadActionPlans(shouldShowWorking: true)
                    })
                    return
                }

                self.generateTableData(actionPlanInstance: actionPlanInstance)
                self.updateView()
        })
    }
    
    // Create a multidimensional array that will contain objectives and tasks. The first item in any given row will
    // be an objective item, followed by n number of tasks associated with the objective. *Note - It is possible that
    // a task may be associated with multiple objectives, in this case, a single task may be displayed multiple times
    // under different objectives.
    private func generateTableData(actionPlanInstance: MHVActionPlansResponseActionPlanInstance_?)
    {
        // Clear any existing table data
        self.tableData = Array<Array<Any>>()
        
        // Iterate through all action plans to find objectives.
        actionPlanInstance?.plans?.forEach(
            { (plan) in
                
                // Itereate though all objectives and add each one to the start of a new array.
                plan.objectives.forEach(
                    { (objective) in
                        
                        // Only show objectives that are not inactive
                        if (objective.state == MHVObjectiveStateEnum.mhvInactive())
                        {
                            return
                        }
                        
                        // Add the action plan to the dictionary so it can be looked up using the objective identifier.
                        self.actionPlanDictionary.updateValue(plan, forKey: objective.identifier)
                        
                        var sectionArray = Array<Any>()
                        sectionArray.append(objective)
                        
                        // For each objective, iterate though the action plan's associated tasks and check the objective Id.
                        let tasks = self.tasksSortedBySchedule(associatedTasks: plan.associatedTasks)

                        for task in tasks
                        {
                            // Only show tasks that are not archived
                            if (task.status == MHVActionPlanTaskInstanceStatusEnum.mhvArchived())
                            {
                                continue
                            }
                            
                            // Check if the task is associated with the objective and add it to the array (after the objective)
                            task.associatedObjectiveIds.forEach(
                                { (objectiveId) in
                                    
                                    if (objective.identifier == objectiveId)
                                    {
                                        sectionArray.append(task)
                                        return
                                    }
                            })
                        }
                        
                        self.tableData.append(sectionArray)
                })
        })
    }
    
    // Sorts tasks by the soonest scheduled time
    private func tasksSortedBySchedule(associatedTasks: [MHVActionPlanTaskInstance]?) -> Array<MHVActionPlanTaskInstance>
    {
        if let tasks = associatedTasks
        {
            return tasks.sorted(by:
                { (plan1, plan2) -> Bool in
                    if let plan1Schedules = plan1.schedules
                    {
                        // Get the sorted schedule for the first plan
                        let schedule1 = self.sortedSchedules(schedules: plan1Schedules)
                        guard schedule1.count > 0 && schedule1[0].scheduledTime != nil else
                        {
                            return true
                        }
                        
                        if let plan2Schedules = plan2.schedules
                        {
                            // Get the sorted schedule for the second plan
                            let schedule2 = self.sortedSchedules(schedules: plan2Schedules)
                            guard schedule2.count > 0 && schedule2[0].scheduledTime != nil else
                            {
                                return true
                            }
                            
                            // Compere the scheduled times (ordered ascending)
                            return (schedule1[0].scheduledTime?.toDate())! < (schedule2[0].scheduledTime?.toDate())!
                        }
                    }
                    
                    return true
            })
        }
        
        return []
    }
    
    // Sorts schedules by the soonest scheduled time
    private func sortedSchedules(schedules: [MHVSchedule]) -> [MHVSchedule]
    {
        return schedules.sorted(by:
            { (schedule1, schedule2) -> Bool in
                
                if let time1 = schedule1.scheduledTime
                {
                    if let time2 = schedule2.scheduledTime
                    {
                        return time1.toDate() < time2.toDate()
                    }
                }
                
                return true
        })
    }
    
    // MARK: - Helpers
    
    private func updateView()
    {
        DispatchQueue.main.async
            {
                if (!self.isViewLoaded)
                {
                    self.didDeferUpdate = true
                    return
                }
                
                self.didDeferUpdate = false
                
                self.refreshControl.endRefreshing()
                self.hideWorking()
                self.tableView.reloadData()
        }
        
    }
    
    // MARK: - UITableViewDataSource
    
    internal func numberOfSections(in tableView: UITableView) -> Int
    {
        return self.tableData.count
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.tableData[section].count;
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        switch indexPath.row
        {
        case 0:
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "ObjectiveCell", for: indexPath) as! ManageHabitsObjectiveTableViewCell
            let objective = self.tableData[indexPath.section][indexPath.row] as! MHVObjective
            
            if let planInstance = self.actionPlanDictionary[objective.identifier]
            {
                cell.setObjective(objective: objective, planInstance: planInstance)
            }
            
            return cell
            
        default:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "HabitCell", for: indexPath) as! ManageHabitsTaskTableViewCell
            let taskInstance = self.tableData[indexPath.section][indexPath.row] as! MHVActionPlanTaskInstance
            cell.setTaskInstance(taskInstance: taskInstance)
            
            return cell
        }
    }
    
    // MARK: - UITableViewDelegate

    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row
        {
        case 0:
            self.navigateToObjectiveDetail(cell: self.tableView.cellForRow(at: indexPath) as! ManageHabitsObjectiveTableViewCell)
            break
        default:
            self.navigateToHabitDetail(cell: self.tableView.cellForRow(at: indexPath) as! ManageHabitsTaskTableViewCell)
        }
    }

    // MARK: - Navigation
    
    private func navigateToObjectiveDetail(cell: ManageHabitsObjectiveTableViewCell)
    {
        DispatchQueue.main.async
            {
                self.performSegue(withIdentifier: "ObjectiveSegue", sender: cell)
        }
    }
    
    private func navigateToHabitDetail(cell: ManageHabitsTaskTableViewCell)
    {
        DispatchQueue.main.async
            {
                self.performSegue(withIdentifier: "HabitSegue", sender: cell)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let objectiveCell = sender as? ManageHabitsObjectiveTableViewCell
        {
            let objectiveViewController = segue.destination as! ObjectiveDetailViewController
            
            if let objective = objectiveCell.objective
            {
                if let planInstance = objectiveCell.planInstance
                {
                    objectiveViewController.setObjective(objective: objective, planInstance: planInstance)
                }
            }
        }
        else if let taskCell = sender as? ManageHabitsTaskTableViewCell
        {
            let taskViewController = segue.destination as! HabitDetailViewController
            
            if let taskInstance = taskCell.taskInstance
            {
                taskViewController.setTaskInstance(taskInstance: taskInstance)
            }
        }
        
    }
    
    @IBAction func prepareForUnwindSeque(segue: UIStoryboardSegue)
    {
        self.loadActionPlans(shouldShowWorking: true)
    }
}
