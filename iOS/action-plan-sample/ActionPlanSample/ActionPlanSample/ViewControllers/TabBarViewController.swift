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
import HealthVault

class TabBarViewController: UITabBarController, UITabBarControllerDelegate
{
    override func viewDidLoad()
    {
        super.viewDidLoad()

        super.delegate = self

        let signOutButton = UIBarButtonItem(title: "Sign out", style: .plain, target: self, action: #selector(signOutButtonPressed))
        
        self.navigationItem.leftBarButtonItem = signOutButton
        
        self.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        let todayStoryboard = UIStoryboard(name: "Today", bundle: nil)
        let todayViewController = todayStoryboard.instantiateInitialViewController()
        
        let myHabitsStoryboard = UIStoryboard(name: "MyHabits", bundle: nil)
        let myHabitsViewController = myHabitsStoryboard.instantiateInitialViewController()
        
        let healthDataStoryboard = UIStoryboard(name: "HealthData", bundle: nil)
        let healthDataStatusViewController = healthDataStoryboard.instantiateInitialViewController() as! HealthDataStatusViewController
        
        todayViewController!.tabBarItem = UITabBarItem(title: "Today", image: #imageLiteral(resourceName: "home-icon"), tag: 0)
        myHabitsViewController!.tabBarItem = UITabBarItem(title: "My Habits", image: #imageLiteral(resourceName: "habits-icon"), tag: 1)
        healthDataStatusViewController.tabBarItem = UITabBarItem(title: "Data", image: #imageLiteral(resourceName: "sources-icon"), tag: 2)
        
        self.viewControllers = [todayViewController!, myHabitsViewController!, healthDataStatusViewController]
        
        // Trigger didSelect for the first view controller so bar button item and title will be shown correctly
        self.tabBarController(self, didSelect: todayViewController!)
    }
    
    func signOutButtonPressed()
    {
        HVConnection.signOut(presentingViewController: self, completion:
        {
            self.navigateToCreatePlanViewController()
        })
    }
    
    func updateRightBarButton(viewController: RightBarButtonProtocol)
    {
        DispatchQueue.main.async
            {
                if let item = viewController.rightBarButtonSystemItem
                {
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: item,
                                                                                  target: viewController,
                                                                                  action: Selector(("rightBarButtonAction")))
                }
                else
                {
                    self.navigationItem.rightBarButtonItem = nil
                }
        }
    }
    
    // MARK: - UITabBarControllerDelegate
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController)
    {
        self.title = viewController.title
        self.navigationItem.rightBarButtonItem = nil

        if let vc = viewController as? RightBarButtonProtocol
        {
            self.updateRightBarButton(viewController: vc)
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
                self.navigationController?.popToRootViewController(animated: false)
        }
    }
}
