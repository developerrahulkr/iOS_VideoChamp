//
//  FeedbackMsgImageCell.swift
//  videoChamp
//
//  Created by iOS Developer on 09/03/22.
//

import UIKit

class FeedbackMsgImageCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var imgFeedback: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateData(inData : CMGetFeedbackServiceData) {
        lblTime.text = Utility.shared.timeFormatConvertor(string: inData.createdAt ?? "")
        
        guard let url = URL(string: inData.image ?? "") else { return }
        
        if let imgdata = try? Data(contentsOf: url) {
            let image: UIImage = UIImage(data: imgdata)!
            imgFeedback.image = image
        }
    }
    
    
}
