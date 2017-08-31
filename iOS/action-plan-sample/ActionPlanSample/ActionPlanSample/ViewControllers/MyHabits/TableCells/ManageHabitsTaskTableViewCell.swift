//
//  ManageHabitsTaskTableViewCell.swift
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

class ManageHabitsTaskTableViewCell: UITableViewCell
{
    @IBOutlet var taskImageView: UIImageView!
    @IBOutlet var taskNameLabel: UILabel!
    @IBOutlet var imageBackgroundView: UIView!

    public private(set) var taskInstance: MHVActionPlanTaskInstance?

    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        // Round the corners of the background image
        self.imageBackgroundView.layer.cornerRadius = imageBackgroundView.frame.size.height / 2
    }
    
    public func setTaskInstance(taskInstance: MHVActionPlanTaskInstance?)
    {
        self.taskInstance = taskInstance
        self.updateCell()
    }
    
    private func updateCell()
    {
        DispatchQueue.main.async
            {
                if (self.taskInstance == nil)
                {
                    self.taskImageView.image = nil
                    self.taskNameLabel.text = ""
                }
                else
                {
                    if let urlString = self.taskInstance?.thumbnailImageUrl
                    {
                        let url = URL(string: urlString)
                        self.taskImageView.setImage(url: url!)
                    }
                    else
                    {
                        self.taskImageView.image = nil
                    }
                    
                    self.taskNameLabel.text = self.taskInstance?.name
                }
                
                
        }
    }

}
