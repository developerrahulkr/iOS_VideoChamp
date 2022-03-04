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
        lblTime.text = Utility.shared.timeConvertor(string: inData.createdAt ?? "")
        lblMsg.text = inData.message
        isType = inData.type ?? ""
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        // Configure the view for the selected state
    }
    
}
