//
//  CameraCodeCell3.swift
//  videoChamp
//
//  Created by iOS Developer on 18/02/22.
//

import UIKit

class CameraCodeCell3: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var lblHelpful: UILabel!
    @IBOutlet weak var lblText1: UILabel!
    @IBOutlet weak var lblText2: UILabel!
    @IBOutlet weak var lblText3: UILabel!
    @IBOutlet weak var viewGreen1: UIView!
    @IBOutlet weak var viewGreen2: UIView!
    @IBOutlet weak var viewGreen3: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cardView.layer.cornerRadius = 25.0
        viewGreen1.circleView()
        viewGreen2.circleView()
        viewGreen2.circleView()
        
        
        
    }
    
    
    
    

   
    
}
