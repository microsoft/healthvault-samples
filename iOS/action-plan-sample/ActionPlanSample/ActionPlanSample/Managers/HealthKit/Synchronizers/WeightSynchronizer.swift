//
//  WeightSynchronizer.swift
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

class WeightSynchronizer: HealthKitSampleSynchronizerBase
{
    override func typesForAuthorization() -> [HKObjectType]?
    {
        guard let type = self.typeForQuery() else
        {
            return nil
        }
        
        return [type]
    }
    
    override func typeForQuery() -> HKObjectType?
    {
        return HKObjectType.quantityType(forIdentifier: .bodyMass)
    }
    
    override func healthVaultClass() -> AnyClass?
    {
        return MHVWeight.self
    }
    
    override func addValues(to thing:MHVThing, sample: HKSample)
    {
        if let weightThing = thing.weight(), let weightSample = sample as? HKQuantitySample
        {
            weightThing.when = MHVDateTime(date: sample.endDate)
            
            let unit = self.unitsDictionary?[weightSample.quantityType]
            
            if unit == HKUnit(from: .kilogram)
            {
                weightThing.inKg = weightSample.quantity.doubleValue(for: unit!)
            }
            else
            {
                weightThing.inPounds = weightSample.quantity.doubleValue(for: HKUnit(from: "lb"))
            }
        }
    }
}
