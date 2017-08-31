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

protocol TimelineTaskTableViewCellDelegate: class
{
    func navigateToTrackTask(cellData: TimelineTaskCellData)
    func trackTask(cellData: TimelineTaskCellData)
}

class TimelineTaskTableViewCell: UITableViewCell
{
    @IBOutlet weak var imageBackgroundView: UIView!
    @IBOutlet weak var taskImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var trackTaskButton: TrackButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noAlarmIcon: UIImageView!
    
    var cellData: TimelineTaskCellData?
    weak var delegate: TimelineTaskTableViewCellDelegate?

    deinit
    {
        stopObserving()
    }
    
    //MARK: - Cell Setup
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        // Round the corners of the background image
        self.imageBackgroundView.layer.cornerRadius = imageBackgroundView.frame.size.height / 2
    }

    override func prepareForReuse()
    {
        print("prepareForReuse")
        
        super.prepareForReuse()

        stopObserving()
        
        titleLabel.textColor = .black
        trackTaskButton.isHidden = false
        activityIndicator.stopAnimating()
        taskImageView.image = nil
        cellData = nil
    }
    
    func setupCell(taskData: TimelineTaskCellData, delegate: TimelineTaskTableViewCellDelegate?)
    {
        self.cellData = taskData
        self.delegate = delegate

        startObserving()

        updateCell()
    }
    
    private func updateCell()
    {
        guard let cellData = self.cellData else
        {
            print("Expected cellData")
            return
        }
        
        DispatchQueue.main.async
            {
                self.titleLabel.text = cellData.taskName
                self.timeLabel.text = cellData.taskTimes
                self.noAlarmIcon.isHidden = cellData.hasReminder
                
                self.trackTaskButton.count = cellData.occurrenceCount
                self.trackTaskButton.countMax = cellData.requiredNumberOfOccurrences
                self.trackTaskButton.frequency = cellData.frequency
                self.trackTaskButton.isTapToUndo = cellData.undoTimer != nil && (cellData.undoTimer?.isValid)!
                
                if let imageUrl = cellData.imageUrl
                {
                    self.taskImageView.setImage(url: imageUrl)
                }
                
                if cellData.isWorking
                {
                    self.trackTaskButton.isHidden = true
                    self.activityIndicator.startAnimating()
                }
                else
                {
                    self.trackTaskButton.isHidden = false
                    self.activityIndicator.stopAnimating()
                }
                
                self.trackTaskButton.updateStyle()
                
                if cellData.occurrenceCount >= cellData.requiredNumberOfOccurrences
                {
                    self.titleLabel.textColor = .appDarkGray
                }
        }
    }
    
    //MARK: - KVO
    
    func startObserving()
    {
        if cellData != nil
        {
            addObserver(self, forKeyPath: #keyPath(cellData.isWorking), options: [.new, .old], context: nil)
        }
    }

    func stopObserving()
    {
        if cellData != nil
        {
            removeObserver(self, forKeyPath: #keyPath(cellData.isWorking))
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if keyPath == #keyPath(cellData.isWorking)
        {
            self.updateCell()
        }
    }

    //MARK: - Track Action

    @IBAction func trackTaskButtonAction(_ sender: Any)
    {
        guard let cellData = self.cellData else
        {
            print("Expected cellData")
            return
        }
        guard let delegate = self.delegate else
        {
            print("Can not track without delegate")
            return
        }
        
        if cellData.occurrenceCount >= cellData.requiredNumberOfOccurrences
        {
            //Already logged the max, show out-of-window tracking view
            delegate.navigateToTrackTask(cellData: cellData)
            return
        }
        
        // If tracking will be out of window, show out-of-window tracking view
        if !cellData.isTrackingInWindow(date: Date())
        {
            delegate.navigateToTrackTask(cellData: cellData)
            return
        }
        
        if cellData.undoTimer != nil && (cellData.undoTimer?.isValid)!
        {
            //Tap to undo is showing, stop timer and updateCell
            cellData.undoTimer?.invalidate()
            cellData.undoTimer = nil
            
            updateCell()
            return
        }
        
        //Show short undo period then track it
        cellData.undoTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block:
            {
                (timer) in
                
                //Timer fired, trigger the tracking action
                cellData.undoTimer = nil
                
                delegate.trackTask(cellData: cellData)
        })
        
        updateCell()
    }
}
