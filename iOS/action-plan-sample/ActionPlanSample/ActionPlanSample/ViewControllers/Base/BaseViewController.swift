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


import UIKit

class BaseViewController: UIViewController
{
    var workingView: UIView?

    // MARK: - Working Indicators

    func showWorking()
    {
        DispatchQueue.main.async
            {
                if (self.workingView != nil)
                {
                    return
                }
                
                // Disable the sign out/back button
                self.enableLeftBarButton(enable: false)
                
                
                if let activityIndicator = UIView.loadFromXib(name: "ActivityIndicatorView")
                {
                    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
                    
                    self.workingView = activityIndicator
                    self.view.addSubview(activityIndicator)
                    self.view.addConstraints(activityIndicator.constraints(toFillView: self.view))
                    self.view.setNeedsUpdateConstraints()
                    self.view.updateConstraintsIfNeeded()
                }
        }
    }
    
    func hideWorking()
    {
        DispatchQueue.main.async
            {
                if (self.workingView == nil)
                {
                    return
                }
                
                self.workingView?.removeFromSuperview()
                self.workingView = nil
                
                // Enable the sign out/back button
                self.enableLeftBarButton(enable: true)
        }
    }

    // MARK: - Error Alert

    func showAlertWithError(error: Error?,
                            defaultMessage: String?,
                            includeCancel: Bool,
                            retryAction: ((Void) -> Void)?)
    {
        var message = error?.localizedDescription
        
        if (message == nil)
        {
            message = defaultMessage ?? "An unknown error occcured."
        }
        
        // show error and/or retry
        let alert = UIAlertController.init(title: "Action Plan Error",
                                           message: message,
                                           preferredStyle: .alert)
        
        // If retry action, add Try again button, and optional Cancel button
        if retryAction != nil
        {
            if (includeCancel)
            {
                let alertActionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler:nil)
                alert.addAction(alertActionCancel)
            }
            
            let alertActionRetry = UIAlertAction(title: "Try again", style: .default, handler:
            { (action) in
                
                retryAction!()
            })            
            alert.addAction(alertActionRetry)
        }
        else
        {
            let alertActionOK = UIAlertAction(title: "OK", style: .default, handler:nil)            
            alert.addAction(alertActionOK)
        }
        
        DispatchQueue.main.async
            {
                self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    private func enableLeftBarButton(enable: Bool)
    {
        DispatchQueue.main.async
            {
                self.navigationItem.setHidesBackButton(!enable, animated: true)
                
                var leftButton: UIBarButtonItem?
                
                if let leftItems = self.navigationItem.leftBarButtonItems
                {
                    leftItems.forEach(
                        { (item) in
                        
                            item.isEnabled = enable
                    })
                }
                
                leftButton = self.parent?.navigationItem.leftBarButtonItem
                
                leftButton?.isEnabled = enable
        }
    }
}
