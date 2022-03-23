//
//  FeedbackSectionCell.swift
//  videoChamp
//
//  Created by iOS Developer on 22/02/22.
//

import UIKit

class FeedbackSectionCell: UITableViewHeaderFooterView {

    @IBOutlet weak var lblTitle1: UILabel!
    @IBOutlet weak var lblTitle2: UILabel!
    
    override func layoutSubviews() {
        lblTitle2.font = UIFont.systemFont(ofSize: 15.0, weight: .light)
        lblTitle1.font = UIFont.systemFont(ofSize: 15.0, weight: .light)
    }
   

}


