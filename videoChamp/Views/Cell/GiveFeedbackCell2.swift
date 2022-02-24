//
//  GiveFeedbackCell2.swift
//  videoChamp
//
//  Created by iOS Developer on 22/02/22.
//

import UIKit

class GiveFeedbackCell2: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var tfView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cardView.layer.cornerRadius = 20.0
        
    }
    
}
