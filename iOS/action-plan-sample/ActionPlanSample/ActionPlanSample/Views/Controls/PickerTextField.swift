//
//  PickerTextField.swift
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

class PickerTextField: UITextField, UIPickerViewDataSource, UIPickerViewDelegate
{
    public var pickerView = UIPickerView()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.setupInputView()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        self.setupInputView()
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.setupInputView()
    }
    
    private func setupInputView()
    {
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.inputView = self.pickerView
        
        let accessoryView = UIView.loadFromXib(name: "EditHabitAccessoryView") as? EditHabitAccessoryView
        accessoryView?.responder = self
        self.inputAccessoryView = accessoryView
    }
    
    // MARK: - UIPickerViewDataSource
    
    internal func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        // Subclasses should override
        return 0
    }
    
    internal func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        // Subclasses should override
        return 0
    }
}
