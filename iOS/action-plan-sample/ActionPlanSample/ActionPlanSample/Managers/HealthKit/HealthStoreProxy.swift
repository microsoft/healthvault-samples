//
//  HealthStoreProxy.swift
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

class HealthStoreProxy : HealthStoreProxyProtocol
{
    private var store: HKHealthStore
    
    init(store: HKHealthStore)
    {
        self.store = store;
    }
    
    func isHealthDataAvailable() -> Bool
    {
        return HKHealthStore.isHealthDataAvailable()
    }
    
    func authorizationStatus(for type: HKObjectType) -> HKAuthorizationStatus
    {
        return self.store.authorizationStatus(for: type)
    }
    
    func requestAuthorization(toShare typesToShare: Set<HKSampleType>?, read typesToRead: Set<HKObjectType>?, completion: @escaping (Bool, Error?) -> Swift.Void)
    {
        self.store.requestAuthorization(toShare: typesToShare, read: typesToRead, completion: completion)
    }
    
    func execute(_ query: HKQuery)
    {
        self.store.execute(query)
    }
    
    func stop(_ query: HKQuery)
    {
        self.store.stop(query)
    }
    
    func enableBackgroundDelivery(for type: HKObjectType, frequency: HKUpdateFrequency, withCompletion completion: @escaping (Bool, Error?) -> Swift.Void)
    {
        self.store.enableBackgroundDelivery(for: type, frequency: frequency, withCompletion: completion)
    }
    
    func disableBackgroundDelivery(for type: HKObjectType, withCompletion completion: @escaping (Bool, Error?) -> Swift.Void)
    {
        self.store.disableBackgroundDelivery(for: type, withCompletion: completion)
    }
    
    func disableAllBackgroundDelivery(completion: @escaping (Bool, Error?) -> Swift.Void)
    {
        self.store.disableAllBackgroundDelivery(completion: completion)
    }
    
    func preferredUnits(for quantityTypes: Set<HKQuantityType>, completion: @escaping ([HKQuantityType : HKUnit], Error?) -> Void)
    {
        self.store.preferredUnits(for: quantityTypes, completion: completion)
    }
}
