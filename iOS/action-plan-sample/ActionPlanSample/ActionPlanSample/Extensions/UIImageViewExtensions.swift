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

public extension UIImageView
{
    /// Set image on a UIImageView asynchronously
    ///
    /// - Parameter url: Url to load the data for the image
    func setImage(url: URL)
    {
        // Correct image is already showing,
        if self.image != nil && self.tag == url.hashValue
        {
            return
        }
        
        self.image = nil
        
        //Use tag to tell if image URL changed while data was loading
        self.tag = url.hashValue
        
        DispatchQueue.global().async
        {
            do
            {
                let data = try Data.init(contentsOf: url)
                let image = UIImage.init(data: data)
                
                DispatchQueue.main.async
                {
                    if (image != nil && self.tag == url.hashValue)
                    {
                        self.image = image
                    }
                }
            }
            catch
            {
            }
        }
    }
}
