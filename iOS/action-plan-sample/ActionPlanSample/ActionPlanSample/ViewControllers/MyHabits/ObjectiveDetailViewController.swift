//
//  ObjectiveDetailViewController.swift
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

import UIKit
import HealthVault

class ObjectiveDetailViewController: BaseViewController
{
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var imageBackgroundView: UIView!
    @IBOutlet var titleLable: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var stopWorkingOnThisButton: UIButton!
    
    private var objective: MHVObjective?
    private var planInstance: MHVActionPlanInstance?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Add a border to the button
        self.stopWorkingOnThisButton.layer.borderWidth = 1.0
        self.stopWorkingOnThisButton.layer.borderColor = UIColor.appMediumGray.cgColor
        
        // Round the corners of the background image
        self.imageBackgroundView.layer.cornerRadius = imageBackgroundView.frame.size.height / 2

        self.updateView()
    }
    
    public func setObjective(objective: MHVObjective?, planInstance: MHVActionPlanInstance?)
    {
        self.objective = objective
        self.planInstance = planInstance
        
        self.updateView()
    }
    
    private func updateView()
    {
        DispatchQueue.main.async
            {
                if (!self.isViewLoaded)
                {
                    return
                }
                
                if (self.objective == nil)
                {
                    self.imageView.image = nil
                    self.titleLable.text = nil
                    self.descriptionLabel.text = nil
                }
                else
                {
                    if let urlString = self.planInstance?.imageUrl
                    {
                        let url = URL(string: urlString)
                        self.imageView.setImage(url: url!)
                    }
                    else
                    {
                        self.imageView.image = nil
                    }
                    
                    self.titleLable.text = self.objective?.name
                    self.descriptionLabel.text = self.objective?.descriptionText
                }
        }
    }
    
    // MARK: - HealthVault
    
    private func endObjective()
    {
        guard let client = HVConnection.currentConnection?.remoteMonitoringClient(), self.planInstance?.identifier != nil, self.objective?.identifier != nil else
        {
            var errorMessage = "The remote monitoring client is nil."
            
            if (self.planInstance?.identifier == nil)
            {
                errorMessage = "The plan has no valid identifier."
            }
            else if (self.objective?.identifier == nil)
            {
                errorMessage = "The objective has no valid identifier."
            }
            
            self.showAlertWithError(error: nil, defaultMessage: "An error occurred while attempting to updated the action plan task - " + errorMessage, includeCancel: true, retryAction:nil)
            
            self.setStopWorkingOnThisButtonEnabled(enabled: true)
            
            return
        }
        
        self.showWorking()
        
        // Delete the objective from the user's action plan.
        client.actionPlanObjectivesDelete(withActionPlanId: (self.planInstance?.identifier)!, objectiveId: (self.objective?.identifier)!, completion:
            { (error) in
            
                guard error == nil else
                {
                    super.showAlertWithError(error: error,
                                             defaultMessage: "An unknown error occurred while ending the action plan objective.",
                                             includeCancel: false,
                                             retryAction:
                        {
                            self.setStopWorkingOnThisButtonEnabled(enabled: true)
                            self.hideWorking()
                    })
                    
                    return
                }
                
                // Post a notification that tasks have changed
                NotificationCenter.default.post(name: Constants.TasksChangedNotification, object: nil)
                
                // Check if the user has any remaining action plans.
                client.actionPlansGet(completion:
                    { (actionPlanInstance, error) in
                        
                        guard error == nil else
                        {
                            super.showAlertWithError(error: error,
                                                     defaultMessage: "An unknown error occurred while checking the status of action plans.",
                                                     includeCancel: false,
                                                     retryAction:nil)
                            
                            self.navigateToCreatePlanViewController()
                            
                            return
                        }
                        
                        if ((actionPlanInstance?.plans?.count)! > 0)
                        {
                            // The user still has an action plan - Navigate back to manaage habits
                            self.navigateBack()
                        }
                        else
                        {
                            // The user does not have an action plan - Navigate to the root view controller (to allow for sample plan creation)
                            self.navigateToCreatePlanViewController()
                        }
                })
        })
    }
    
    // MARK: - Helpers
    
    private func setStopWorkingOnThisButtonEnabled(enabled: Bool)
    {
        DispatchQueue.main.async
            {
                self.stopWorkingOnThisButton.isEnabled = enabled;
        }
    }
    
    // MARK: - Actions
    
    @IBAction func stopWorkingOnThisPressed(sender: UIButton)
    {
        let alert = UIAlertController.init(title: "Are you sure you want to stop working on this?",
                                           message: "All tasks you are working on for '" + self.titleLable.text! + "' will also be removed",
                                           preferredStyle: .alert)
        
        let alertActionCancel = UIAlertAction(title: "Cancel", style: .default, handler:nil)
        alert.addAction(alertActionCancel)
        
        let alertActionStop = UIAlertAction(title: "Stop", style: .destructive, handler:
        { (action) in
            
            self.setStopWorkingOnThisButtonEnabled(enabled: false)
            self.endObjective()
        })
        alert.addAction(alertActionStop)
        
        DispatchQueue.main.async
            {
                self.present(alert, animated: true, completion: nil)
        }
    }

    // MARK: - Navigation
    
    private func navigateToCreatePlanViewController()
    {
        // Refresh the plan status before navigating back
        let rootViewController = self.navigationController?.viewControllers[0] as! RootViewController
        rootViewController.checkPlanStatus()
        
        DispatchQueue.main.async
            {
                self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    private func navigateBack()
    {
        DispatchQueue.main.async
            {
                self.performSegue(withIdentifier: "UnwindToManageHabits", sender: self)
        }
    }
}
