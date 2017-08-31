//
//  HealthDataManagementViewController.swift
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

class HealthDataManagementViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate
{

    @IBOutlet var tableView: UITableView!

    private var observer: HealthKitQueryObserver?
    private let healthKitManager = HealthKitManagerFactory.healthKitManager()
    private var sources = [HKSource]()
    private var enabledSources = [HKSource]()
    private var didReturnFromPrompt = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Override the back functionality so we can navigate to the correct view controller
        let backSpace = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        backSpace.width = -8
        let backButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "back-icon"), style: .plain, target: self, action: #selector(backButtonPressed))
        self.navigationItem.leftBarButtonItems = [backSpace, backButton];
        
        self.tableView.contentInset = UIEdgeInsetsMake(-44, 0, 0, 0)
        self.loadData()
    }
    
    public func setObserver(observer: HealthKitQueryObserver)
    {
        self.observer = observer;
    }
    
    private func loadData()
    {
        if let observer = self.observer
        {
            if (observer.canStartObserving)
            {
                self.showWorking()
                
                self.healthKitManager?.sources(for: [observer], completion:
                    { (sourcesDictionary, errors) in
                        
                        if let sources = sourcesDictionary[observer]
                        {
                            if (sources.count > 0)
                            {
                                self.sources = Array(sources)
                                self.setEnabledSources()
                                self.updateView()
                                return
                            }
                        }
                        
                        self.sources.removeAll()
                        self.setEnabledSources()
                        self.updateView()
                })
            }
        }
    }
    
    private func updateView()
    {
        DispatchQueue.main.async
            {
                self.tableView.reloadData()
                self.hideWorking()
        }
    }
    
    // MARK: HealthKit
    
    private func setEnabledSources()
    {
        if let observer = self.observer,
        let predicate = self.healthKitManager?.predicate(for: observer)
        {
            // Clear the enabledSources array.
            self.enabledSources = [HKSource]()
            
            // The predicate contains the source - Add it to the enabledSources array
            self.enabledSources = self.sources.filter({predicate.description.contains($0.bundleIdentifier)})
        }
        else
        {
            // If there is no predicate, all sources are enabled.
            self.enabledSources = self.sources
        }
    }
    
    private func requestPermissions()
    {
        if let observer = self.observer
        {
            self.showWorking()
            
            self.healthKitManager?.requestPermissions(with: [observer],
            { (success, error) in
                                                        
                if (!success)
                {
                    let observerName = ObserverNameMap.name(for: observer.queryType) ?? ""
                    
                    self.showAlertWithError(error: error, defaultMessage: "The request to read " + observerName + " data from HealthKit was unsuccessful.", includeCancel: false, retryAction: nil)
                    
                    self.hideWorking()
                }
                else
                {
                    DispatchQueue.main.async
                        {
                            self.navigationItem.setHidesBackButton(true, animated: false)
                            self.navigationItem.leftBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .done,
                                                                                  target: self,
                                                                                  action: #selector(self.doneButtonPressed))]
                    }
                    
                    self.didReturnFromPrompt = true
                    self.loadData()
                }
            })
        }
    }
    
    private func isEnabled(source: HKSource) -> Bool
    {
        return self.enabledSources.contains(source)
    }
    
    private func setSource(source: HKSource, enabled: Bool)
    {
        let isSourceEnabled = self.enabledSources.contains(source)
        
        if (!isSourceEnabled && enabled)
        {
            self.enabledSources.append(source)
        }
        else if (isSourceEnabled && !enabled)
        {
            if let index = self.enabledSources.index(of: source)
            {
                self.enabledSources.remove(at: index)
            }
        }
        
        if let observer = self.observer
        {
            if (self.sources.count == self.enabledSources.count)
            {
                // All sources are enabled - remove the predicate so results will not be filtered.
                self.healthKitManager?.removePredicate(for: observer)
            }
            else
            {
                // One or more sources have been disabled - generate a source filtering predicate.
                self.healthKitManager?.setPredicate(predicate: HKQuery.predicateForObjects(from: Set(self.enabledSources)),
                                                    for:observer)
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    internal func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (self.isObserverActive())
        {
            return self.sources.count
        }
        
        return 1
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if (self.isObserverActive())
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SourceCell", for: indexPath) as! HealthDataSourceTableViewCell
            let source =  self.sources[indexPath.row]
            cell.setName(name: source.name, isOn: self.isEnabled(source:source), reloadClosure:
                { (cell) in
                
                    self.setSource(source: source, enabled: cell.enableSwitch.isOn)
            })
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EnableCell", for: indexPath)

        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    internal func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String?
    {
        
        
        if let appName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String,
            let observerName = ObserverNameMap.name(for: self.observer?.queryType)
        {
            if (self.isObserverActive())
            {
                if (self.sources.count < 1)
                {
                    return "No " + observerName + " data was found. Make sure " + appName + " can read data from the Health app.\n\nGo to Health -> Sources -> " + appName
                }
            }
            else
            {
                return "Enable " + appName + " to send " + observerName + " data from the Health app to your HealthVault account."
            }
        }
        
        return "Multiple health data sources may result in duplicated data."
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (!self.isObserverActive())
        {
            self.requestPermissions()
        }
    }
    
    // MARK: - Helpers
    
    func isObserverActive() -> Bool
    {
        if let observer = self.observer
        {
            return observer.canStartObserving
        }
        
        return false
    }
    
    // MARK: - Actions
    
    func doneButtonPressed()
    {
        // Start the observer before navigating back.
        self.observer?.start()
        self.navigateBack()
    }
    
    func backButtonPressed()
    {
        self.navigateBack()
    }
    
    // MARK: - Navigation
    
    private func navigateBack()
    {
        DispatchQueue.main.async
            {
                if (self.isObserverActive())
                {
                     self.performSegue(withIdentifier: "UnwindToDataManagement", sender: self)
                }
                else
                {
                     self.performSegue(withIdentifier: "UnwindToTypeSelection", sender: self)
                }
        }
    }
}
