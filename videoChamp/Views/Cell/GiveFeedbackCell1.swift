//
//  GiveFeedbackCell1.swift
//  videoChamp
//
//  Created by iOS Developer on 28/02/22.
//

import UIKit

class GiveFeedbackCell1: UITableViewCell,UITextFieldDelegate {

//    var callBAck :((_ str: String)) -> ())?
    var callBack : ((_ str : String) -> ())?
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var tfTitle: UITextField!

    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.callBack?(textField.text ?? "")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        tfTitle.delegate = self
        // Initialization code
        cardView.layer.cornerRadius = cardView.bounds.height/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
