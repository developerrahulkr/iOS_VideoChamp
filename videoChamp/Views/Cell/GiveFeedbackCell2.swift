//
//  GiveFeedbackCell2.swift
//  videoChamp
//
//  Created by iOS Developer on 22/02/22.
//

import UIKit

class GiveFeedbackCell2: UITableViewCell {

    @IBOutlet weak var lblCounting: UILabel!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var tfView: UITextView!
    var wordLimit = 100
    
    @IBOutlet weak var lblCount: UILabel!
    var callBack : ((_ str : String) -> ())?
    var callBackUpdateCounting : ((_ str : String) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cardView.layer.cornerRadius = 20.0
        tfView.delegate = self
    }
    
    override func layoutSubviews() {
    }
}


extension GiveFeedbackCell2 : UITextViewDelegate {
    

    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.callBack?(textView.text ?? "")
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        self.callBackUpdateCounting?(textView.text ?? "")
        guard let textViewText = textView.text, let rangeOfTextToReplace = Range(range, in: textViewText) else {
            print("Error Messgae...")
            return false
        }
        let substringToReplace = textViewText[rangeOfTextToReplace]
        let count = textViewText.count - substringToReplace.count + text.count
        wordLimit -= 1
//        print("word Remaining : \(wordLimit)")
        if wordLimit >= 0 {
        }else{
//            giveFeedbackViewModel.giveFeedbackSection[0].secTitle2 = "Maximum 0 word in the blogs."
//            CMFeedBack(secTitle: "0", secTitle2: "100")
            wordLimit = 0
        }
        return count < 100
    }
    
    
    
}


