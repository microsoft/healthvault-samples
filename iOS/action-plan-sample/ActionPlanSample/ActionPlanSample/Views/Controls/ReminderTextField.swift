//
//  ReminderTextField.swift
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

class ReminderTextField: PickerTextField
{
    public var offset: Int?
    public var scheduleIndex = 0
    public var isOn: Bool
    {
        get { return self.offset != nil }
    }
    
    private var date = Date()
    private var updateIsOn: (Void) -> Void = {_ in }
    private let offsets = [(text:"Off", value:nil),
                           (text:"", value:0),
                           (text:"5 minutes before ", value:-300),
                           (text:"10 minutes before ", value:-600),
                           (text:"15 minutes before ", value:-900),
                           (text:"30 minutes before ", value:-1800),
                           (text:"1 hour before ", value:-3600),
                           (text:"2 hours before ", value:-7200),
                           (text:"4 hours before ", value:-14400),
                           (text:"8 hours before ", value:-28800)
                           ]
    
    public func setDate(date: Date, offset: Int?, scheduleIndex: Int, updateIsOn:@escaping (Void) -> Void)
    {
        self.date = date
        self.offset = offset
        self.scheduleIndex = scheduleIndex
        self.updateIsOn = updateIsOn
        
        self.updateText()
        self.selectRow()
    }
    
    private func selectRow()
    {
        var row = 0
        
        if let offset = self.offset
        {
            repeat
            {
                let data = self.offsets[row]
                
                if (data.value == offset)
                {
                    break
                }
                
                row += 1
            }
            while (row < offsets.count)
        }
        
        self.pickerView.selectRow(row, inComponent: 0, animated: false)
    }
    
    // MARK: - Helpers
    
    private func updateText()
    {
        var date = self.date
        
        if let offset = self.offset
        {
            date = self.date.addingTimeInterval(TimeInterval(offset))
        }
        
        self.text = self.timeString(date: date)
    }
    
    private func timeString(date: Date) -> String
    {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        
        return formatter.string(from: date)
    }
    
    // MARK: - UIPickerViewDataSource
    
    override func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return self.offsets.count
    }
    
    // MARK: - UIPickerViewDelegate
    
    internal func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        var text = self.offsets[row].text
        
        if (row > 0)
        {
            text = text + self.timeString(date: self.date)
        }
        
        return text
    }
    
    internal func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        self.offset = self.offsets[row].value
        self.updateText()
        self.updateIsOn()
    }
}
