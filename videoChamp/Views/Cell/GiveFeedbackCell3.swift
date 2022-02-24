//
//  GiveFeedbackCell3.swift
//  videoChamp
//
//  Created by iOS Developer on 22/02/22.
//

import UIKit

class GiveFeedbackCell3: UITableViewCell {

    @IBOutlet weak var imgLeftView: UIView!
    @IBOutlet weak var imgRightView: UIView!
    @IBOutlet weak var imgLeft: UIImageView!
    @IBOutlet weak var imgRight: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgLeftView.layer.cornerRadius = 20.0
        imgRightView.layer.cornerRadius = 20.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
