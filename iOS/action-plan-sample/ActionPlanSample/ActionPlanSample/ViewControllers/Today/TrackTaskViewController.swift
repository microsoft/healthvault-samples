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

class TrackTaskViewController: BaseViewController
{
    private var taskId: String?
    private var taskDescription: String?
    private var imageUrl: URL?

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageBackgroundView: UIView!
    @IBOutlet weak var trackTaskButton: DefaultButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var innerView: UIView!
    
    @IBAction func trackTaskButtonAction(_ sender: Any)
    {
        trackTask()
    }
    
    @IBAction func cancelButtonAction(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Populate view controller content from TimelineTaskCellData
    public func setCellData(cellData: TimelineTaskCellData)
    {
        title = cellData.taskName
        taskId = cellData.taskId!

        taskDescription = cellData.taskDescription
        imageUrl = cellData.imageUrl
    }

    // Populate view controller content from MHVActionPlanTaskInstance
    public func setTaskInstance(taskInstance: MHVActionPlanTaskInstance)
    {
        title = taskInstance.name
        taskId = taskInstance.identifier!

        taskDescription = taskInstance.shortDescription

        if let url = URL.init(string: taskInstance.thumbnailImageUrl)
        {
            imageUrl = url
        }
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        trackTaskButton.backgroundColor = .appGreen
        descriptionLabel.text = taskDescription ?? ""
        imageBackgroundView.layer.cornerRadius = imageBackgroundView.frame.size.height / 2
        
        innerView.layer.cornerRadius = 20
        innerView.layer.shadowColor = UIColor.black.cgColor
        innerView.layer.shadowRadius = 60
        innerView.layer.shadowOpacity = 1
        
        if let url = self.imageUrl
        {
            imageView.setImage(url: url)
        }
    }
    
    // MARK: - HealthVault

    private func trackTask()
    {
        guard let remoteMonitoringClient = HVConnection.currentConnection?.remoteMonitoringClient() else
        {
            self.showAlertWithError(error: nil,
                                    defaultMessage: "Error tracking task - The remote monitoring client is nil",
                                    includeCancel: false,
                                    retryAction: nil)
            return
        }

        guard let taskId = self.taskId else
        {
            self.showAlertWithError(error: nil,
                                    defaultMessage: "No TaskId",
                                    includeCancel: false,
                                    retryAction: nil)
            return;
        }
        
        let occurrence = MHVTaskTrackingOccurrence()
        occurrence.taskId = taskId
        occurrence.trackingDateTime = MHVZonedDateTime()
        occurrence.trackingDateTime?.date = datePicker.date

        self.showWorking()
        
        remoteMonitoringClient.taskTrackingPost(with: occurrence, completion:
            { (number: MHVTaskTrackingOccurrence?, error: Error?) in
                
                guard error == nil else
                {
                    self.hideWorking()
                    self.showAlertWithError(error: error, defaultMessage: nil, includeCancel: false, retryAction: nil)
                    return
                }
                
                NotificationCenter.default.post(name: Constants.TaskTrackedNotification, object: taskId)

                DispatchQueue.main.async
                    {
                        self.performSegue(withIdentifier: "taskWasLogged", sender: self)
                }
        })
    }
}
