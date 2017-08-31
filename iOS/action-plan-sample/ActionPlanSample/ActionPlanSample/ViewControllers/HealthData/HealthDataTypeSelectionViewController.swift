//
//  HealthDataTypeSelectionViewController.swift
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

class HealthDataTypeSelectionViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet var tableView: UITableView!
    
    private var inactiveObservers = [HealthKitQueryObserver]()
    private let lockObject = NSObject()
    private let healthKitManager = HealthKitManagerFactory.healthKitManager()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.generateTableData()
        self.tableView.reloadData()

        // Do any additional setup after loading the view.
    }
    
    private func generateTableData()
    {
        objc_sync_enter(self.lockObject)
        
        defer
        {
            objc_sync_exit(self.lockObject)
        }
        
        self.inactiveObservers.removeAll()
        
        self.healthKitManager?.allObservers.forEach(
            { (observer) in
                
                if (!observer.canStartObserving)
                {
                    self.inactiveObservers.append(observer)
                }
        })
    }
    
    // MARK: - UITableViewDataSource
    
    internal func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.inactiveObservers.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HealthDataTypeCell", for: indexPath)
        let observer = self.inactiveObservers[indexPath.row]
        cell.textLabel?.text = ObserverNameMap.name(for: observer.queryType)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Navigation
    
    @IBAction  func prepareToUnwind(segue: UIStoryboardSegue, viewController: UIViewController)
    {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let viewController = segue.destination as? HealthDataManagementViewController,
            let cell = sender as? UITableViewCell,
            let indexPath = self.tableView.indexPath(for: cell)
        {
            if (indexPath.row < self.inactiveObservers.count)
            {
                let observer = self.inactiveObservers[indexPath.row]
                viewController.title = ObserverNameMap.name(for: observer.queryType)
                viewController.setObserver(observer: observer)
            }
            
        }
    }

}
