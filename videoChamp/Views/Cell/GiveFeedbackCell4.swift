//
//  GiveFeedbackCell4.swift
//  videoChamp
//
//  Created by iOS Developer on 02/03/22.
//

import UIKit

protocol FeedbackDataDelegate {
    func submitData(tag : Int)
}

class GiveFeedbackCell4: UITableViewCell {

    @IBOutlet weak var btnSubmit: UIButton!
    var delegate : FeedbackDataDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnSubmit.layer.cornerRadius = btnSubmit.bounds.height/2
    }

    @IBAction func onClickedSubmitBtn(_ sender: UIButton) {
        delegate.submitData(tag: sender.tag)
    }
    
   
    
}
