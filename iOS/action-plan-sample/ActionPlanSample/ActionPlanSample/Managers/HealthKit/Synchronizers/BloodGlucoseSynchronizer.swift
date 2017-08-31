//
//  BloodGlucoseSynchronizer.swift
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

class BloodGlucoseSynchronizer: HealthKitSampleSynchronizerBase
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
        return HKObjectType.quantityType(forIdentifier: .bloodGlucose)
    }
    
    override func healthVaultClass() -> AnyClass?
    {
        return MHVBloodGlucose.self
    }
    
    override func addValues(to thing:MHVThing, sample: HKSample)
    {
        if let bgThing = thing.bloodGlucose(), let bgSample = sample as? HKQuantitySample
        {
            bgThing.when = MHVDateTime(date: sample.endDate)
            
            let unit = self.unitsDictionary?[bgSample.quantityType]
            
            if unit == HKUnit.moleUnit(with: .milli, molarMass: HKUnitMolarMassBloodGlucose).unitDivided(by: HKUnit.liter())
            {
                bgThing.inMmolPerLiter = bgSample.quantity.doubleValue(for: unit!)
            }
            else
            {
                bgThing.inMgPerDL = bgSample.quantity.doubleValue(for: HKUnit(from: "mg/dL"))
            }

            if (bgThing.measurementType == nil)
            {
                // HealthKit does not provide a measurement type, so assume whole blood.
                bgThing.measurementType = MHVBloodGlucose.createWholeBloodMeasurementType()
            }
        }
    }
}
