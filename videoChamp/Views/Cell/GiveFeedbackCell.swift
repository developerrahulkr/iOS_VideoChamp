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
        
    }
    
    override func layoutSubviews() {
        cellView.layer.masksToBounds = true
        cellView.layer.cornerRadius = cellView.bounds.height/2
    }
    
}
