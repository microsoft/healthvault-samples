//
//  HealthDataStatusViewController.swift
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
import HealthKit

class HealthDataStatusViewController: BaseViewController, RightBarButtonProtocol, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet var tableView: UITableView!
    
    var rightBarButtonSystemItem : UIBarButtonSystemItem?
    {
        get
        {
            if (self.activeObservers.count == self.healthKitManager?.allObservers.count)
            {
                return nil
            }
            
            return UIBarButtonSystemItem.add
        }
    }
    
    private var refreshControl = UIRefreshControl()
    private var activeObservers = [HealthKitQueryObserver]()
    private let observerLockObject = NSObject()
    private var lastSamples = [HealthKitQueryObserver : HKSample]()
    private let samplesLockObject = NSObject()
    private let healthKitManager = HealthKitManagerFactory.healthKitManager()
    private let store = HealthStoreProxy(store: HKHealthStore())
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.refreshControl.addTarget(self, action: #selector(refreshObservers), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(self.refreshControl)
        self.tableView.contentInset = UIEdgeInsetsMake(-44, 0, 0, 0)
        
        self.loadData()
    }
    
    func refreshObservers()
    {
        if (self.activeObservers.count < 1)
        {
            self.loadData()
            return
        }
        
        let dispatchGroup = DispatchGroup()
        
        self.activeObservers.forEach
            { (observer) in
                
                dispatchGroup.enter()
                
                observer.execute(completion: {(success, error) in dispatchGroup.leave() })
        }
        
        dispatchGroup.notify(queue: DispatchQueue.global())
        {
            self.loadData()
        }
    }
    
    private func loadData()
    {
        objc_sync_enter(self.observerLockObject)
        
        defer
        {
            objc_sync_exit(self.observerLockObject)
        }
        
        self.activeObservers.removeAll()
        
        self.healthKitManager?.allObservers.forEach(
            { (observer) in
            
                if (observer.canStartObserving)
                {
                    self.activeObservers.append(observer)
                }
        })
        
        self.fetchLastSamples
            {
                self.updateView()
        }
    }
    
    private func updateView()
    {
        if let tabBar = self.tabBarController as? TabBarViewController
        {
            tabBar.updateRightBarButton(viewController: self)
        }
        
        DispatchQueue.main.async
            {
                self.refreshControl.endRefreshing()
                self.hideWorking()
                self.tableView.reloadData()
        }
    }
    
    // MARK: - HealthKit
    
    private func fetchLastSamples(completion: @escaping (Void) -> Void)
    {
        if (self.activeObservers.count < 1)
        {
            completion()
            return
        }
        
        if (!self.refreshControl.isRefreshing)
        {
            self.showWorking()
        }
        
        let dispatchGroup = DispatchGroup()
        
        self.activeObservers.forEach
            { (observer) in
                
                dispatchGroup.enter()
                
                let query = HKSampleQuery(sampleType: observer.queryType as! HKSampleType,
                                          predicate: self.healthKitManager?.predicate(for: observer),
                                          limit: 1,
                                          sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)],
                                          resultsHandler:
                    { (query, samples, error) in
                        
                        objc_sync_enter(self.samplesLockObject)
                        self.lastSamples[observer] = samples?.first
                        objc_sync_exit(self.samplesLockObject)
                        
                        dispatchGroup.leave()
                })
                
                self.store.execute(query)
        }
        
        dispatchGroup.notify(queue: DispatchQueue.global())
        {
            completion()
        }
    }
    
    // MARK: - UITableViewDataSource
    
    internal func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let count = self.activeObservers.count
        
        if (self.activeObservers.count == self.healthKitManager?.allObservers.count)
        {
            return count
        }
        
        return count + 1
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if (indexPath.row == self.activeObservers.count)
        {
            return tableView.dequeueReusableCell(withIdentifier: "AddNewCell", for: indexPath)
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TypeCell", for: indexPath) as! HealthDataTypeTableViewCell
            let observer = self.activeObservers[indexPath.row]
            cell.titleLable.text = ObserverNameMap.name(for: observer.queryType)
            cell.subtitleLable.text = self.dateString(from:self.lastSamples[observer]?.startDate)
            return cell
        }
    }
    
    // MARK: - UITableViewDelegate
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Helpers
    
    private func dateString(from date: Date?) -> String
    {
        if let d = date
        {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            
            return "Last reading: " + formatter.string(from: d)
        }
        else
        {
            return "No data"
        }
    }
    
    // MARK: - Actions
    
    func rightBarButtonAction()
    {
        DispatchQueue.main.async
            {
                // Navigate to add sources
                self.performSegue(withIdentifier: "TypeSelectionSegue", sender: self)
        }
        
    }

    // MARK: - Navigation
    
    @IBAction  func prepareToUnwindFromTypeSelection(segue: UIStoryboardSegue, viewController: UIViewController)
    {
        
    }
    
    @IBAction  func prepareToUnwindFromDataManagement(segue: UIStoryboardSegue, viewController: UIViewController)
    {
        self.loadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let viewController = segue.destination as? HealthDataManagementViewController,
            let cell = sender as? HealthDataTypeTableViewCell,
            let indexPath = self.tableView.indexPath(for: cell)
        {
            if (indexPath.row < self.activeObservers.count)
            {
                let observer = self.activeObservers[indexPath.row]
                viewController.title = ObserverNameMap.name(for: observer.queryType)
                viewController.setObserver(observer: observer)
            }
            
        }
    }

}
