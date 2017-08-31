// Copyright (c) Microsoft Corporation.  All rights reserved.
// MIT License
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the ""Software""), to deal
// in the Software without restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
// and to permit persons to whom the Software is furnished to do so, subject to the
// following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or
// substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
// PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
// FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
// DEALINGS IN THE SOFTWARE.

import Foundation
import HealthVault

struct HVConnection
{
    // Mark - HealthVault
    
    // Creates a HealthVault connection using the ActionPlanConfiguration object
    public static let currentConnection: MHVSodaConnectionProtocol? = MHVConnectionFactory.current().getOrCreateSodaConnection(with: ActionPlanConfiguration.configuration())
    
    // Signs the current user out of the application
    public static func signOut(presentingViewController: UIViewController!, completion:((Void) -> Void)?)
    {
        let alert = UIAlertController.init(title: "Sign out",
                                           message: "Would you like to sign out?",
                                           preferredStyle: .alert)
        
        let alertActionCancel = UIAlertAction(title: "Cancel", style: .default, handler:nil)
        alert.addAction(alertActionCancel)
        
        let alertActionSignOut = UIAlertAction(title: "Sign out", style: .destructive, handler:
        { (action) in
            
            HVConnection.currentConnection?.deauthorizeApplication(completion:
                { (error) in
                
                    guard error == nil else
                    {
                        let alert = UIAlertController.init(title: "Sign out error",
                                                           message: "An error occurred while attempting to sign out.",
                                                           preferredStyle: .alert)
                        
                        let alertActionOK = UIAlertAction(title: "OK", style: .default, handler:nil)
                        alert.addAction(alertActionOK)
                        
                        DispatchQueue.main.async
                            {
                                presentingViewController.present(alert, animated: true, completion: nil)
                        }
                        return
                    }
                    

                    // Stop any HealthKit sample observers
                    if let observers = HealthKitManagerFactory.healthKitManager()?.allObservers
                    {
                        HealthKitManagerFactory.healthKitManager()?.stop(observers: observers)
                    }

                    // Remove any reminders
                    ReminderManagerFactory.reminderManager()?.removeAllNotifications()
                    
                    completion?()
            })
        })
        alert.addAction(alertActionSignOut)
        
        DispatchQueue.main.async
            {
                presentingViewController.present(alert, animated: true, completion: nil)
        }
    }
}
