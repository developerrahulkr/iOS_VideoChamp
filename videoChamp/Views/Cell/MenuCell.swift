//
//  MenuCell.swift
//  videoChamp
//
//  Created by iOS Developer on 16/02/22.
//

import UIKit

class MenuCell: UITableViewCell {

    @IBOutlet weak var imgNotification: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnArrow: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblName.font = UIFont.systemFont(ofSize: 15.0, weight: .semibold)
    }
    

    
    @IBAction func onClickedArrowBtn(_ sender: UIButton) {
        
        
    }
    
    
    func updateData(inData : CMModel) {
        imgNotification.image = UIImage(named: inData.imageIcon ?? "")
        lblName.text = inData.name ?? ""
        btnArrow.setImage(UIImage(named: inData.arrowIcon ?? ""), for: .normal)
    }
    
    
}
