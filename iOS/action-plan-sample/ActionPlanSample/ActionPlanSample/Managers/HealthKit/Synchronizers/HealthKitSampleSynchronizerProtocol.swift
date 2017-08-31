//
//  HealthKitSampleSynchronizerProtocol.swift
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

protocol HealthKitSampleSynchronizerProtocol
{
    /// The HealthKit sample type displayed to the user in the authorization UI
    var authorizationTypes: [HKObjectType]? { get }
    
    /// The HealthKit sample type used to query.
    /// In some cases (e.g. blood pressure) a user must authorize each component of blood pressure separately (systolic, diastolic, and heartrate),
    /// but the query will be a single correlation type
    var queryType: HKObjectType? { get }
    
    /// Synchronizes a samples with an external store.
    ///
    /// - Parameters:
    ///   - samples: HealthKit samples to be update or created.
    ///   - deletedSamples: HealthKit samples to be deleted.
    ///   - completion: Envoked when the synchronization process completed.
    func synchronize(samples: [HKSample]?, deletedSamples: [HKDeletedObject]?, completion: @escaping (Error?) -> Void)
    
}
