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
    
    var callBack : ((_ str : String) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cardView.layer.cornerRadius = 20.0
        tfView.delegate = self
    }
}


extension GiveFeedbackCell2 : UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.callBack?(textView.text ?? "")
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = nil
        textView.textColor = .black
    }
}


