//
//  CameraCodeCell.swift
//  videoChamp
//
//  Created by iOS Developer on 18/02/22.
//

import UIKit

class CameraCodeCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblDesc: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cardView.layer.cornerRadius = cardView.bounds.height/2
    }

    func updateData(inData : CMCameraDeviceModel){
        imgUser.image = UIImage(named: inData.imageIcon ?? "")
        lblDesc.text = inData.name ?? ""
    }
    
}
