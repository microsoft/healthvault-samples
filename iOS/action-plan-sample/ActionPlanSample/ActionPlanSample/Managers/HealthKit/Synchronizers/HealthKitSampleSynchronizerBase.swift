//
//  HealthKitSampleSynchronizerBase.swift
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
import HealthVault

class HealthKitSampleSynchronizerBase: HealthKitSampleSynchronizerProtocol
{
    var authorizationTypes: [HKObjectType]? { get { return self.typesForAuthorization() } }
    var queryType: HKObjectType? { get { return self.typeForQuery() } }
    var unitsDictionary: [HKQuantityType : HKUnit]?
    let store: HealthStoreProxyProtocol
    private let thingClient: MHVThingClientProtocol
    private let recordId: UUID
    
    init(store: HealthStoreProxyProtocol,
        thingClient: MHVThingClientProtocol,
        recordId: UUID)
    {
        self.store = store
        self.thingClient = thingClient
        self.recordId = recordId
    }
    
    func synchronize(samples: [HKSample]?, deletedSamples: [HKDeletedObject]?, completion: @escaping (Error?) -> Void)
    {
        // Give subclasses an opportunity to execute code before syncing
        self.willSyncronize(samples: samples, deletedSamples: deletedSamples)
        {
            // First process any deleted samples
            self.delete(samples: deletedSamples)
            { (error) in
                
                guard error == nil else
                {
                    completion(error)
                    return
                }
                
                // Next process any updates and/or creates
                self.createOrUpdate(samples: samples, completion:
                { (error) in
                    
                    // Give subclasses an opportunity to execute code after syncing
                    self.willFinishSyncronize(after:
                        {
                        
                            completion(error)
                    })
                })
            }
        }
    }
    
    private func delete(samples: [HKDeletedObject]?, completion: @escaping (Error?) -> Void)
    {
        // Create an array of identifers from the deleted samples (HealthKit sample ids are stored as the Thing client id property)
        let uuids = samples?.map({ $0.uuid.uuidString })
        
        // Fetch the Things from HealthVault
        self.fetchThings(with: uuids)
        { (things, error) in
            
            if (things != nil && !things!.isEmpty)
            {
                // Delete the Things from HealthVault
                self.thingClient.remove(things!, record: self.recordId, completion: completion)
            }
            else
            {
                completion(error)
            }
        }
    }
    
    private func createOrUpdate(samples: [HKSample]?, completion: @escaping (Error?) -> Void)
    {
        // Create an array of identifers from the samples (HealthKit sample ids are stored as the Thing client id property)
        let uuids = samples?.map({ $0.uuid.uuidString })
        
        // Fetch the Things from HealthVault
        self.fetchThings(with: uuids)
        { (things, error) in
            
            guard error == nil else
            {
                completion(error)
                return
            }
            
            if let types = self.authorizationTypes as? [HKQuantityType]
            {
                self.store.preferredUnits(for: Set(types), completion:
                    { (unitsDictionary, error) in
                    
                        // Try to fetch the preferred units for samples.
                        self.unitsDictionary = unitsDictionary
                        self.applyUpdates(samples: samples, existingThings: things, completion: completion)
                })
            }
            else
            {
                self.applyUpdates(samples: samples, existingThings: things, completion: completion)
            }
            
        }
    }
    
    private func applyUpdates(samples: [HKSample]?, existingThings:[MHVThing]?, completion: @escaping (Error?) -> Void)
    {
        if let updatedThings = self.things(from: samples, existingThings: existingThings)
        {
            self.thingClient.update(updatedThings, record: self.recordId, completion:
                { (thingKeys, error) in
                    
                    completion (error)
            })
        }
        else
        {
            completion(nil)
        }
    }
    
    private func fetchThings(with ids:[String]?, completion: @escaping ([MHVThing]?, Error?) -> Void)
    {
        if (ids != nil && !(ids?.isEmpty)!)
        {
            if let hvClass = self.healthVaultClass(), let query = MHVThingQuery(filter: MHVThingFilter(typeClass: hvClass))
            {
                query.clientIDs = ids
                
                self.thingClient.getThingsWith(query, record: self.recordId)
                { (results, error) in
                    
                    guard error == nil else
                    {
                        completion(nil, error)
                        return
                    }
                    
                    completion(results?.things, nil)
                }
                
                return
            }
        }
        
        completion(nil, nil)
    }
    
    private func things(from samples:[HKSample]?, existingThings:[MHVThing]?) -> [MHVThing]?
    {
        var things = [MHVThing]()
        
        samples?.forEach(
            { (sample) in
                
                var thing: MHVThing?
                
                existingThings?.forEach(
                    { (existingThing) in
                        
                        if let clientId = UUID.init(uuidString: existingThing.data.common.clientID.value)
                        {
                            if (sample.uuid == clientId)
                            {
                                thing = existingThing
                                return
                            }
                        }
                })
                
                // Create a new thing
                if let newThing = thing ?? MHVThing(typedDataClass: healthVaultClass())
                {
                    // Set the clientId to the sample identifier
                    newThing.data.common.clientIDValue = sample.uuid.uuidString
                    self.addValues(to: newThing, sample: sample)
                    things.append(newThing)
                }
        })
        
        return things.count < 1 ? nil : things
    }
    
    // MARK: Subclass overrides
    
    func typesForAuthorization() -> [HKObjectType]?
    {
        return nil
    }
    
    func typeForQuery() -> HKObjectType?
    {
        return nil
    }
    
    func healthVaultClass() -> AnyClass?
    {
        return nil
    }
    
    func addValues(to thing:MHVThing, sample: HKSample)
    {
        
    }
    
    // Subclasses can override to execute code to BEFORE requests to HealthVault are made.
    func willSyncronize(samples: [HKSample]?, deletedSamples: [HKDeletedObject]?, completion:@escaping () -> Void)
    {
        completion()
    }
    
    // Subclasses can override to execute code to AFTER requests to HealthVault are made.
    func willFinishSyncronize(after completion:@escaping () -> Void)
    {
        completion()
    }
}
