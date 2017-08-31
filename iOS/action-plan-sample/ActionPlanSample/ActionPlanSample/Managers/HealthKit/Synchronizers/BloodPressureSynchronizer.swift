//
//  BloodPressureSynchronizer.swift
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

class BloodPressureSynchronizer: HealthKitSampleSynchronizerBase
{
    private var pulseDictionary = [UUID : HKQuantitySample]()
    private let lockObject = NSObject()
    
    override func typesForAuthorization() -> [HKObjectType]?
    {
        guard  let systolicType = HKObjectType.quantityType(forIdentifier: .bloodPressureSystolic),
        let diastolicType = HKObjectType.quantityType(forIdentifier: .bloodPressureDiastolic),
        let heatRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else
        {
            return nil
        }
        
        return [systolicType, diastolicType, heatRateType]
    }
    
    override func typeForQuery() -> HKObjectType?
    {        
        return HKObjectType.correlationType(forIdentifier: .bloodPressure)
    }
    
    override func healthVaultClass() -> AnyClass?
    {
        return MHVBloodPressure.self
    }
    
    override func willSyncronize(samples: [HKSample]?, deletedSamples: [HKDeletedObject]?, completion: @escaping () -> Void)
    {
        // Currently, pulse is not correlated with blood pressure. Fetch heart rate data that has the same start/end dates.
        if let heatRateType = HKObjectType.quantityType(forIdentifier: .heartRate)
        {
            let dispatchGroup = DispatchGroup()
            
            samples?.forEach(
                { sample in
                    
                    dispatchGroup.enter()
                    
                    let predicate = HKQuery.predicateForSamples(withStart: sample.startDate,
                                                                end: nil,
                                                                options: HKQueryOptions.strictStartDate)
                    
                    self.store.execute(HKSampleQuery.init(sampleType: heatRateType,
                                                          predicate: predicate,
                                                          limit: 1,
                                                          sortDescriptors: nil,
                                                          resultsHandler:
                        { (query, pulseSamples, error) in
                            
                            if let pulseSample = pulseSamples?.first as? HKQuantitySample
                            {
                                objc_sync_enter(self.lockObject)
                                self.pulseDictionary[sample.uuid] = pulseSample
                                objc_sync_exit(self.lockObject)
                            }
                            
                            dispatchGroup.leave()
                    }))
            })
            
            dispatchGroup.notify(queue: DispatchQueue.global())
            {
                completion()
            }
        }
        else
        {
            completion()
        }
    }
    
    override func addValues(to thing:MHVThing, sample: HKSample)
    {
        if let bpThing = thing.bloodPressure(), let bpSample = sample as? HKCorrelation
        {
            bpThing.when = MHVDateTime(date: sample.endDate)
            
            if let systolic = bpSample.objects(for: HKObjectType.quantityType(forIdentifier: .bloodPressureSystolic)!).first as? HKQuantitySample
            {
                bpThing.systolicValue = Int32(systolic.quantity.doubleValue(for: HKUnit.millimeterOfMercury()))
            }
            
            if let diastolic = bpSample.objects(for: HKObjectType.quantityType(forIdentifier: .bloodPressureDiastolic)!).first as? HKQuantitySample
            {
                bpThing.diastolicValue = Int32(diastolic.quantity.doubleValue(for: HKUnit.millimeterOfMercury()))
            }
            
            if let pulse = self.pulseDictionary[sample.uuid]
            {
                bpThing.pulseValue = Int32(pulse.quantity.doubleValue(for: HKUnit(from: "count/min")))
            }
        }
    }
}
