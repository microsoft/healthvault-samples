//
//  PermissionsManager
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

class PermissionsManager
{
    // Properties
    public var readTypes = [HKObjectType]()
    public var shareTypes = [HKSampleType]()
    private let store: HealthStoreProxyProtocol
    
    // Initializer
    init(store: HealthStoreProxyProtocol)
    {
        self.store = store
    }
    
    func authorizeHealthKit(_ completion:@escaping (_ success: Bool, _ error: Error?) -> Void)
    {
        // HealthKit not available (for e.g. on iPad)
        if (!self.store.isHealthDataAvailable())
        {
            print("HealthKit is not available on the current device!")
            completion(false, HealthKitError.unavailable)
            return
        }
        
        // Empty Read and Write Types
        if (self.readTypes.isEmpty && self.shareTypes.isEmpty)
        {
            print("HealthKit read and write types were empty!")
            completion(false, HealthKitError.noSpecifiedTypes)
            return
        }
        
        // Get read and write sample types to authorize.
        let readTypes: Set<HKObjectType> =  Set(self.readTypes)
        let shareTypes: Set<HKSampleType> = Set(self.shareTypes)
        
        print("Requesting authorization to read and write types")
        
        self.store.requestAuthorization(toShare: shareTypes, read: readTypes)
        {(success, error) -> Void in

            print((success ? "HealthKit authorization succeeded!" : "HealthKit authorization failed!"))
            
            if let authError = error
            {
                // Error exists.
                print(authError)
            }
            
            completion(success, error)
        }
    }
}
