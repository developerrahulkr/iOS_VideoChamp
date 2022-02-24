//
//  TermsAndConditionsCell.swift
//  videoChamp
//
//  Created by iOS Developer on 16/02/22.
//

import UIKit

class TermsAndConditionsCell: UITableViewCell {

    @IBOutlet weak var lblTermsAndCondition: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lblTermsAndCondition.font = UIFont(name: "ArgentumSans-Light", size: 13.0)
        lblTermsAndCondition.font = UIFont.systemFont(ofSize: 13.0, weight: .light)
    }

   
    
}
