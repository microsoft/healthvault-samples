//
//  ManageHabitsObjectiveTableViewCell.swift
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

class ManageHabitsObjectiveTableViewCell: UITableViewCell
{
    @IBOutlet var planNameLabel: UILabel!
    @IBOutlet var planObjectiveLabel: UILabel!
    @IBOutlet var categoryColorView: UIView!
    @IBOutlet var labelCollection: [UILabel]!
    
    public private(set) var objective: MHVObjective?
    public private(set) var planInstance: MHVActionPlanInstance?
    
    private var categoryColorMap = [MHVActionPlanInstanceCategoryEnum.mhvActivity() : (main: #colorLiteral(red: 0.2705882353, green: 0.8274509804, blue: 0.4470588235, alpha: 1), dark: #colorLiteral(red: 0, green: 0.4392156863, blue: 0.2196078431, alpha: 1)),
                                    MHVActionPlanInstanceCategoryEnum.mhvHealth() : (main: #colorLiteral(red: 0.4352941176, green: 0.6901960784, blue: 0, alpha: 1), dark: #colorLiteral(red: 0.2352941176, green: 0.4274509804, blue: 0, alpha: 1)),
                                    MHVActionPlanInstanceCategoryEnum.mhvSleep() : (main: #colorLiteral(red: 0.1529411765, green: 0.5647058824, blue: 0.8509803922, alpha: 1), dark: #colorLiteral(red: 0.01568627451, green: 0.3529411765, blue: 0.6352941176, alpha: 1)),
                                    MHVActionPlanInstanceCategoryEnum.mhvStress() : (main: #colorLiteral(red: 0.1019607843, green: 0.631372549, blue: 0.7137254902, alpha: 1), dark: #colorLiteral(red: 0, green: 0.4156862745, blue: 0.4862745098, alpha: 1))]
    
    public func setObjective(objective: MHVObjective?, planInstance: MHVActionPlanInstance?)
    {
        guard objective != nil && planInstance != nil else
        {
            return
        }
        
        self.objective = objective
        self.planInstance = planInstance
        self.updateCell()
    }

    private func updateCell()
    {
        DispatchQueue.main.async
            {
                if (self.objective == nil)
                {
                    self.planNameLabel.text = ""
                    self.planObjectiveLabel.text = ""
                    self.categoryColorView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                }
                else
                {
                    self.planNameLabel.text = self.objective?.name
                    self.planObjectiveLabel.text = self.planInstance?.name
                    
                    if let category = self.planInstance?.category
                    {
                        if let color = self.categoryColorMap[category]
                        {
                            self.categoryColorView.backgroundColor = color.main
                            self.updateLabelColors(color: color.dark)
                            return
                        }
                    }
                    
                    self.categoryColorView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    self.updateLabelColors(color: #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1))
                }
        }
    }
    
    private func updateLabelColors(color: UIColor)
    {
        DispatchQueue.main.async
            {
                for label in self.labelCollection
                {
                    label.textColor = color
                }
        }
    }

}
