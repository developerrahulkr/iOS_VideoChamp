//
//  NotificationCell.swift
//  videoChamp
//
//  Created by iOS Developer on 16/02/22.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var lblNotification: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblNotification.layer.cornerRadius = lblNotification.bounds.height/2
    }
    
    override func layoutSubviews() {
        cardView.layer.cornerRadius = 14.0
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateData(inData : CMGetFeedbackData) {
        lblTitle.text = inData.title ?? ""
        lblMsg.text = inData.desc ?? ""
        lblTime.text = Utility.shared.timeConvertor(string: inData.time ?? "")
    }
    
    func updateFeedbackData(inData : CMGetFeedbackData) {
        lblTitle.text = inData.title ?? ""
        lblMsg.text = inData.desc ?? ""
        lblTime.text = Utility.shared.timeConvertor(string: inData.time ?? "")
    }
    
}
