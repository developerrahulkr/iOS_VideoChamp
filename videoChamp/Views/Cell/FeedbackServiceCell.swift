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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        // Configure the view for the selected state
    }
    
}
