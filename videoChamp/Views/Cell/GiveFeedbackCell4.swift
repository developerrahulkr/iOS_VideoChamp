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
        DispatchQueue.main.async {
            self.btnSubmit.applyGradient1(colorOne: .init(hexString: "#F9B200"), ColorTwo: .init(hexString: "#E63B11"))
        }
        
        btnSubmit.layer.cornerRadius = 22
    }

    @IBAction func onClickedSubmitBtn(_ sender: UIButton) {
        delegate.submitData(tag: sender.tag)
    }
    
   
    
}
