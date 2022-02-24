//
//  GiveFeedbackCell.swift
//  videoChamp
//
//  Created by iOS Developer on 22/02/22.
//

import UIKit

class GiveFeedbackCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var tfTitle: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellView.layer.cornerRadius = cellView.bounds.height/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
