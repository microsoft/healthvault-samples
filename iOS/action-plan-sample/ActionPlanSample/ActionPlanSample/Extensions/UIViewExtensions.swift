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

public extension UIView
{
    /// Load a view from a xib file.
    /// Can be just view in a xib, or have .swift class
    ///
    /// - Parameter name: .xib file name to load
    /// - Returns: the view
    static func loadFromXib(name: String) -> UIView?
    {
        let nib = UINib(nibName: name, bundle: nil)
        
        guard let view = nib.instantiate(withOwner: nil, options: nil).first as? UIView else
        {
            print("Could not load view from nib file.")
            return nil
        }
        
        return view
    }
    
    func constraints(toFillView fillView: UIView) -> [NSLayoutConstraint]
    {
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(NSLayoutConstraint.init(item: self,
                                                   attribute: .top,
                                                   relatedBy: .equal,
                                                   toItem: fillView,
                                                   attribute: .top,
                                                   multiplier: 1,
                                                   constant: 0))
        constraints.append(NSLayoutConstraint.init(item: self,
                                                   attribute: .bottom,
                                                   relatedBy: .equal,
                                                   toItem: fillView,
                                                   attribute: .bottom,
                                                   multiplier: 1,
                                                   constant: 0))
        constraints.append(NSLayoutConstraint.init(item: self,
                                                   attribute: .left,
                                                   relatedBy: .equal,
                                                   toItem: fillView,
                                                   attribute: .left,
                                                   multiplier: 1,
                                                   constant: 0))
        constraints.append(NSLayoutConstraint.init(item: self,
                                                   attribute: .right,
                                                   relatedBy: .equal,
                                                   toItem: fillView,
                                                   attribute: .right,
                                                   multiplier: 1,
                                                   constant: 0))
        
        return constraints
    }
}
