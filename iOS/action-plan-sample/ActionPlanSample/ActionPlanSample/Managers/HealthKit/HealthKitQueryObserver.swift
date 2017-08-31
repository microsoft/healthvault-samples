//
//  HealthKitQueryObserver.swift
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
import HealthKit

class HealthKitQueryObserver: NSObject
{
    public var predicateDelegate: HealthKitQueryPredicateDelegate?
    public private(set) var isObserving = false
    public var authorizationTypes: [HKObjectType]? { return self.synchronizer.authorizationTypes }
    public var queryType: HKObjectType? { return self.synchronizer.queryType }
    public var lastExecutionDate: Date?
    {
        if let key = self.queryType?.identifier, let date = self.userDefaultsProxy.object(forKey: key + self.lastExecutionKeySuffix) as? Date
        {
            return date
        }
        
        return nil
    }
    public var canStartObserving : Bool
    {
        if let types = self.authorizationTypes
        {
            for type in types
            {
                if (self.store.authorizationStatus(for: type) == .notDetermined)
                {
                    return false
                }
            }
            
            return true
        }
        
        return false
    }
    
    private var observerQuery: HKObserverQuery?
    private var observerLockObject = NSObject()
    private let store: HealthStoreProxyProtocol
    private let userDefaultsProxy: UserDefaultsProxyProtocol
    private let synchronizer: HealthKitSampleSynchronizerProtocol
    private let lastExecutionKeySuffix = "-Last-Execution-Date"
    private let anchorKeySuffix = "-Anchor"
    
    init(store: HealthStoreProxyProtocol,
        userDefaultsProxy: UserDefaultsProxyProtocol,
        synchronizer: HealthKitSampleSynchronizerProtocol)
    {
        self.store = store
        self.userDefaultsProxy = userDefaultsProxy
        self.synchronizer = synchronizer
    }
    
    /// Starts the observer query and enables background deliveries of HealthKit samples for the observer's authorizationTypes.
    public func start()
    {
        guard self.store.isHealthDataAvailable() && self.canStartObserving else
        {
            return
        }
        
        objc_sync_enter(self.observerLockObject)
        
        defer
        {
            objc_sync_exit(self.observerLockObject)
        }
        
        if (self.isObserving)
        {
            return
        }
        
        self.isObserving = true
        
        if let authTypes = self.authorizationTypes, let queryType = self.queryType
        {
            self.enableBackgroundDelivery(for: authTypes,
                                          frequency: .immediate)
            { (success, errors) in
                if (success)
                {
                    print("Starting observer query for " + queryType.debugDescription)
                    self.store.execute(self.query())
                }
            }
        }
    }
    
    /// Stops the observer query and disables background deliveries of HealthKit samples for the observer's authorizationTypes.
    /// All persisted data for the observer will be deleted.
    public func stop()
    {
        guard self.store.isHealthDataAvailable() else
        {
            return
        }
        
        objc_sync_enter(self.observerLockObject)
        
        defer
        {
            objc_sync_exit(self.observerLockObject)
        }
        
        if (!self.isObserving)
        {
            return
        }
        
        if let authTypes = self.authorizationTypes, let queryType = self.queryType
        {
            self.disableBackgroundDelivery(for: authTypes)
            { (success, errors) in
                
                print("Stopping observer query for " + queryType.debugDescription)
                self.store.stop(self.query())
                self.deleteAnchor(key: self.queryType?.identifier)
                self.removeExecutionDate()
                
                objc_sync_enter(self.observerLockObject)
                self.isObserving = false
                objc_sync_exit(self.observerLockObject)
            }
        }
    }
    
    
    /// Forces the execution of the observer's query and synchronized data to an external store.
    ///
    /// - Parameter completion: A closure that is executed with a Bool indicating the success or failure of the operation and an optional error.
    /// - Parameter success: A bool indicating whether the operation was successful.
    /// - Parameter error: Optional - an error with details about the failure if an operation is unsuccessful.
    public func execute(completion: @escaping (_ success: Bool, _ error: Error?) -> Void)
    {
        if let type = self.queryType as? HKSampleType
        {
           self.executeAnchorQuery(type: type, completion: completion)
        }
        else
        {
            completion(false, HealthKitError.noSpecifiedTypes)
        }
    }
    
    private func query() -> HKObserverQuery
    {
        if (self.observerQuery != nil)
        {
            return self.observerQuery!
        }
        
        if let type = self.queryType as? HKSampleType
        {
            self.observerQuery = HKObserverQuery(sampleType: type,
                                                 predicate: self.predicateDelegate?.predicate(for: self),
                                                 updateHandler:
                { (query, completion, error) in
                    
                    guard error == nil else
                    {
                        print("The " + self.queryType.debugDescription + " query has returned an error. " + error!.localizedDescription)
                        return
                    }
                    
                    if (query == self.observerQuery)
                    {
                        self.handleObservedQuery(query: query, completion: completion)
                    }
            })
        }
        
        return self.observerQuery!
    }
    
    private func handleObservedQuery(query: HKObserverQuery, completion:@escaping HealthKit.HKObserverQueryCompletionHandler)
    {
        if let type = query.objectType as? HKSampleType
        {
            self.executeAnchorQuery(type: type)
            { (success, error) in
                completion()
            }
        }
        else
        {
            completion()
        }
    }
    
    private func executeAnchorQuery(type:HKSampleType, completion: @escaping (Bool, Error?) -> Void)
    {
        if let identifier = self.queryType?.identifier
        {
            let anchoredQuery = HKAnchoredObjectQuery(type: type,
                                                      predicate: self.predicateDelegate?.predicate(for: self),
                                                      anchor: self.anchor(key: identifier),
                                                      limit: HKObjectQueryNoLimit)
            { (query, samples, deletedSamples, anchor, error) in
                
                guard error == nil else
                {
                    print("The " + self.queryType.debugDescription + " anchored query has returned an error. " + error!.localizedDescription)
                    completion(false, error)
                    return
                }
                
                self.synchronizer.synchronize(samples: samples, deletedSamples: deletedSamples)
                { (error) in
                    
                    guard error == nil else
                    {
                        print("an error occured while synchronizing " + self.queryType.debugDescription + " samples")
                        completion(false, error)
                        return
                    }
                    
                    self.saveAnchor(anchor: anchor, key: identifier)
                    self.updateLastExecutionDate()
                    completion(true, nil)
                }
            }
            
            self.store.execute(anchoredQuery)
        }
    }
    
    private func enableBackgroundDelivery(for types: [HKObjectType], frequency: HKUpdateFrequency, completion: @escaping (Bool, [Error]) -> Void)
    {
        var didSucceed = true
        var errors = [Error]()
        let lockObject = NSObject()
        
        let dispatchGroup = DispatchGroup()
        
        types.forEach
            { (type) in
                
                dispatchGroup.enter()
                
                self.store.enableBackgroundDelivery(for: type,
                                                    frequency: .immediate,
                                                    withCompletion:
                    { (success, error) in
                        
                        if (success)
                        {
                            print("Enabled background delivery for " + type.debugDescription)
                        }
                        else if (error != nil)
                        {
                            didSucceed = false
                            objc_sync_enter(lockObject)
                            errors.append(error!)
                            objc_sync_exit(lockObject)
                            print("an error occured enabling background delivery for " + type.debugDescription)
                        }
                        
                        dispatchGroup.leave()
                })
        }
        
        dispatchGroup.notify(queue: DispatchQueue.global())
        {
            completion(didSucceed, errors)
        }
    }
    
    private func disableBackgroundDelivery(for types: [HKObjectType], completion: @escaping (Bool, [Error]) -> Void)
    {
        var didSucceed = true
        var errors = [Error]()
        let lockObject = NSObject()
        
        let dispatchGroup = DispatchGroup()
        
        types.forEach
            { (type) in
                
                dispatchGroup.enter()
                
                self.store.disableBackgroundDelivery(for: type,
                                                     withCompletion:
                    { (success, error) in
                        
                        if (success)
                        {
                            print("Disabled background delivery for " + type.debugDescription)
                        }
                        else if (error != nil)
                        {
                            didSucceed = false
                            objc_sync_enter(lockObject)
                            errors.append(error!)
                            objc_sync_exit(lockObject)
                            print("an error occured disabling background delivery for " + type.debugDescription)
                        }
                        
                        dispatchGroup.leave()
                })
        }
        
        dispatchGroup.notify(queue: DispatchQueue.global())
        {
            completion(didSucceed, errors)
        }
    }
    
    /// Mark - User Defaults
    
    private func updateLastExecutionDate()
    {
        if let key = self.queryType?.identifier
        {
            self.userDefaultsProxy.set(Date(), forKey: key + self.lastExecutionKeySuffix)
        }
    }
    
    private func removeExecutionDate()
    {
        if let key = self.queryType?.identifier
        {
            self.userDefaultsProxy.removeObject(forKey: key + self.lastExecutionKeySuffix)
        }
    }
    
    private func saveAnchor(anchor: HKQueryAnchor?, key: String)
    {
        if let newAnchor = anchor
        {
            let data = NSKeyedArchiver.archivedData(withRootObject: newAnchor)
            self.userDefaultsProxy.set(data, forKey: key + self.anchorKeySuffix)
        }
    }
    
    private func deleteAnchor(key: String?)
    {
        if let anchorKey = key
        {
            self.userDefaultsProxy.removeObject(forKey: anchorKey + self.anchorKeySuffix)
        }
    }
    
    private func anchor(key: String) -> HKQueryAnchor?
    {
        if let data = self.userDefaultsProxy.data(forKey: key + self.anchorKeySuffix)
        {
           return NSKeyedUnarchiver.unarchiveObject(with: data) as? HKQueryAnchor
        }
        
        return nil
    }

}
