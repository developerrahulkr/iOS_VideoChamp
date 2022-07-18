//
//  FeedbackServiceCell.swift
//  videoChamp
//
//  Created by iOS Developer on 22/02/22.
//

import UIKit

class FeedbackServiceCell: UITableViewCell {
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var lblTime: UILabel!
    var isType = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func updateData(inData : CMGetFeedbackServiceData) {
        lblTime.text = Utility.shared.timeFormatConvertor(string: inData.createdAt ?? "")
        lblMsg.text = inData.message
        isType = inData.type ?? ""
    }
    
}
