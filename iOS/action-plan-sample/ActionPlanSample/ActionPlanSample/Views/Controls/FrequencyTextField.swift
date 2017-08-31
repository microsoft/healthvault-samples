//
//  FrequencyTextField.swift
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

class FrequencyTextField: PickerTextField
{
    public var occurrenceCount = 0
    public var windowType = WindowType.daily
    
    private let windowTypeStrings = ["day",
                                     "week"]
    
    public func setOccurrenceCount(occurrenceCount: Int, windowType: WindowType)
    {
        self.occurrenceCount = occurrenceCount
        self.windowType = windowType
        
        self.updateText()
        
        self.pickerView.selectRow(occurrenceCount - 1, inComponent: 0, animated: false)
        self.pickerView.selectRow(windowType.rawValue, inComponent: 2, animated: false)
    }
    
    // MARK: - Helpers
    
    private func updateText()
    {
        self.text = "Do this " + String(self.occurrenceCount) + "x" + " per " + self.windowTypeStrings[self.windowType.rawValue]
    }
    
    // MARK: - UIPickerViewDataSource
    
    override func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 3
    }
    
    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        switch component
        {
        case 0:
            return 20
        case 2:
            return 2
        default:
            return 1
        }
    }
    
    // MARK: - UIPickerViewDelegate
    
    internal func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat
    {
        if (component == 1)
        {
            return 50.0
        }
        
        return 100.0
    }
    
    internal func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        switch component
        {
        case 0:
            return String(row + 1) + "x"
        case 2:
            return self.windowTypeStrings[row]
        default:
            return "per"
        }
    }
    
    internal func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        switch component
        {
        case 0:
            self.occurrenceCount = row + 1
        case 2:
            self.windowType = WindowType(rawValue: row)!
        default:
            break
        }
        
        self.updateText()
    }
}
