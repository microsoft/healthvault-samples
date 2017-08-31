//
//  HealthKitManager.swift
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

class HealthKitManager : NSObject, HealthKitQueryPredicateDelegate
{
    public let allObservers: [HealthKitQueryObserver]
    private let store: HealthStoreProxyProtocol
    private let userDefaults: UserDefaultsProxy
    private let permissionsManager: PermissionsManager
    private var predicateDictionary = [String : NSPredicate]()
    private let lockObject = NSObject()
    private var predicateDictionaryKey = "Predicate-Dictionary"
    
    init(store: HealthStoreProxyProtocol,
         userDefaults: UserDefaultsProxy,
         permissionsManager: PermissionsManager,
         observerFactory: HealthKitQueryObserverFactory,
         synchronizers: [HealthKitSampleSynchronizerProtocol])
    {
        self.store = store
        self.userDefaults = userDefaults
        self.permissionsManager = permissionsManager
        self.allObservers = observerFactory.observers(with: synchronizers)
        
        super.init()
        
        if let data = self.userDefaults.data(forKey: self.predicateDictionaryKey),
            let dictionary = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String : NSPredicate]
        {
            self.predicateDictionary = dictionary
        }
        
        self.allObservers.forEach
            { (observer) in
            
                observer.predicateDelegate = self
        }
    }
    
    public func requestPermissions(with observers:[HealthKitQueryObserver], _ completion:@escaping (_ success: Bool, _ error: Error?) -> Void)
    {
        self.permissionsManager.readTypes = self.authorizationTypes(from: observers)
        self.permissionsManager.authorizeHealthKit(completion)
    }
    
    public func setPredicate(predicate: NSPredicate, for observer:HealthKitQueryObserver)
    {
        if let identifier = observer.queryType?.identifier
        {
            objc_sync_enter(self.lockObject)
            self.predicateDictionary[identifier] = predicate
            self.savePredicateDictionary()
            objc_sync_exit(self.lockObject)
        }
    }
    
    public func removePredicate(for observer:HealthKitQueryObserver)
    {
        if let identifier = observer.queryType?.identifier
        {
            objc_sync_enter(self.lockObject)
            self.predicateDictionary[identifier] = nil
            self.savePredicateDictionary()
            objc_sync_exit(self.lockObject)
        }
    }
    
    public func start(observers: [HealthKitQueryObserver])
    {
        observers.forEach(
            { (observer) in
                
                observer.start()
        })
    }
    
    public func stop(observers: [HealthKitQueryObserver])
    {
        observers.forEach(
            { (observer) in
                
                observer.stop()
        })
    }
    
    public func sources(for observers:[HealthKitQueryObserver], completion:@escaping ([HealthKitQueryObserver : Set<HKSource>], [Error]?) -> Void)
    {
        let dispatchGroup = DispatchGroup()
        let lockObject = NSObject()
        var sourcesDictionary = [HealthKitQueryObserver : Set<HKSource>]()
        var errors = [Error]()
        
        observers.forEach
            { (observer) in
            
                if let type = observer.queryType as? HKSampleType
                {
                    dispatchGroup.enter()
                    
                    let query = HKSourceQuery(sampleType: type,
                                              samplePredicate: nil,
                                              completionHandler:
                        { (query, sources, error) in
                            
                            if (error != nil)
                            {
                                objc_sync_enter(lockObject)
                                errors.append(error!)
                                objc_sync_exit(lockObject)
                            }
                            else if (sources != nil)
                            {
                                objc_sync_enter(lockObject)
                                sourcesDictionary[observer] = sources
                                objc_sync_exit(lockObject)
                            }

                            dispatchGroup.leave()
                    })
                    
                    self.store.execute(query)
                }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.global())
        {
            completion(sourcesDictionary, errors)
        }
    }
    
    private func authorizationTypes(from observers:[HealthKitQueryObserver]) -> [HKObjectType]
    {
        var types = [HKObjectType]()
        
        observers.forEach
            { (observer) in
                
                observer.authorizationTypes?.forEach(
                    { (type) in
                        
                        types.append(type)
                })
        }
        
        return types
    }
    
    private func savePredicateDictionary()
    {
        let data = NSKeyedArchiver.archivedData(withRootObject: self.predicateDictionary)
        self.userDefaults.set(data, forKey: self.predicateDictionaryKey)
    }
    
    private func deletePredicateDictionary()
    {
        self.userDefaults.removeObject(forKey: self.predicateDictionaryKey)
    }
    
    // MARK: - HealthKitQueryPredicateDelegate
    
    func predicate(for observer: HealthKitQueryObserver) -> NSPredicate?
    {
        if let identifier = observer.queryType?.identifier
        {
            return self.predicateDictionary[identifier]
        }
        
        return nil
    }
    
}
