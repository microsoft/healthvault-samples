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

class TrackButton: UIButton
{
    var countMax: Int = 1
    var count: Int = 0
    var isTapToUndo: Bool = false
    var frequency: String?
    
    var grayOutlineLayer = CAShapeLayer.init()
    var progressOutlineLayer = CAShapeLayer.init()
    var backgroundFillLayer = CAShapeLayer.init()
    var selectedLayer = CAShapeLayer.init()
    
    // MARK: - Styling
    
    override var isHighlighted: Bool
    {
        didSet
        {
            if isHighlighted
            {
                let path = CGMutablePath()
                
                path.addEllipse(in: self.bounds)
                
                selectedLayer.path = path
                selectedLayer.fillColor = UIColor.appTrackButtonHighlighted.cgColor
                self.layer.insertSublayer(self.selectedLayer, at: 0)
            }
            else
            {
                selectedLayer.removeFromSuperlayer()
            }
        }
    }
    
    func updateStyle()
    {
        DispatchQueue.main.async
            {
                self.backgroundColor = .clear
                
                self.titleLabel?.numberOfLines = 0
                self.titleLabel?.textAlignment = .center
                
                if self.count >= self.countMax
                {
                    self.greenCheckStyle()
                }
                else if self.countMax == 1
                {
                    self.oneOccurrenceStyle()
                }
                else
                {
                    self.multipeOccurrencesStyle()
                }
                
                if (self.isTapToUndo)
                {
                    //Show tap to undo and start undo timer
                    self.setTitle("tap to\nundo", for: .normal)
                    self.setTitleColor(.appGreen, for: .normal)
                }
        }
    }
    
    func greenCheckStyle()
    {
        //Complete, style green check
        let path = CGMutablePath()
        
        path.addEllipse(in: self.bounds.insetBy(dx: 8, dy: 8))
        
        self.backgroundFillLayer.path = path
        self.backgroundFillLayer.fillColor = UIColor.appGreen.cgColor
        self.layer .insertSublayer(self.backgroundFillLayer, below: self.imageView?.layer)
        
        self.setImage(#imageLiteral(resourceName: "checkmark"), for: .normal)
        self.setTitle(nil, for: .normal)
        self.setTitleColor(.white, for: .normal)
        
        self.grayOutlineLayer .removeFromSuperlayer()
        self.progressOutlineLayer .removeFromSuperlayer()
    }

    func oneOccurrenceStyle()
    {
        //Only one occurrence, thin border with "tap to log"
        let path = CGMutablePath()
        
        path.addEllipse(in: self.bounds)
        
        self.grayOutlineLayer.path = path
        self.grayOutlineLayer.lineWidth = 1.0;
        self.grayOutlineLayer.strokeColor = UIColor.appLightGray.cgColor
        self.grayOutlineLayer.fillColor = UIColor.clear.cgColor
        self.layer .addSublayer(self.grayOutlineLayer)
        
        self.setImage(nil, for: .normal)
        self.setTitle("tap to\nlog", for: .normal)
        self.setTitleColor(.appDarkGray, for: .normal)

        self.backgroundFillLayer .removeFromSuperlayer()
        self.progressOutlineLayer .removeFromSuperlayer()
    }
    
    func multipeOccurrencesStyle()
    {
        //More than one occurrence, thick progress bar as button border with "x/y Z"
        let path = CGMutablePath()
        
        path.addEllipse(in: self.bounds)
        
        self.grayOutlineLayer.path = path
        self.grayOutlineLayer.lineWidth = 4.0;
        self.grayOutlineLayer.strokeColor = UIColor.appLightGray.cgColor
        self.grayOutlineLayer.fillColor = UIColor.clear.cgColor
        self.layer .addSublayer(self.grayOutlineLayer)
        
        let fillPath = CGMutablePath()
        
        let percent: CGFloat = CGFloat(self.count) / CGFloat(self.countMax)
        
        fillPath.addArc(center: CGPoint.init(x: self.bounds.size.width/2, y: self.bounds.size.height/2),
                        radius: self.bounds.size.width/2,
                        startAngle: CGFloat(Double.pi * 1.5),
                        endAngle: CGFloat(Double.pi * 1.5) + (CGFloat(Double.pi * 2.0) * percent),
                        clockwise: false)
        
        self.progressOutlineLayer.path = fillPath
        self.progressOutlineLayer.lineWidth = 4.0;
        self.progressOutlineLayer.strokeColor = UIColor.appGreen.cgColor
        self.progressOutlineLayer.fillColor = UIColor.clear.cgColor
        self.layer .addSublayer(self.progressOutlineLayer)
        
        if let frequency = self.frequency
        {
            self.setTitle("\(self.count)/\(self.countMax)\n\(frequency)", for: .normal)
        }
        else
        {
            self.setTitle("\(self.count)/\(self.countMax)", for: .normal)
        }
        self.setImage(nil, for: .normal)

        self.setTitleColor(.appDarkGray, for: .normal)

        self.backgroundFillLayer .removeFromSuperlayer()
    }
}
