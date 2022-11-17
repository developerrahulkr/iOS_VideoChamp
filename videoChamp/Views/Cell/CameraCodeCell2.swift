//
//  CameraCodeCell2.swift
//  videoChamp
//
//  Created by iOS Developer on 18/02/22.
//

import UIKit
import GradientView

protocol CameraCodeDelegate {
    func resendCode(tag : Int)
    func shareCode(tag : Int)
}

class CameraCodeCell2: UITableViewCell {

    @IBOutlet weak var cardView: GradientView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: GradientView!
    @IBOutlet weak var lblCode: UILabel!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnResend: UIButton!
    
    var delegate : CameraCodeDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        DispatchQueue.main.async {
            
            self.cardView.layer.cornerRadius = 30.0
            self.bottomView.layer.cornerRadius = 25
            self.cardView.colors = [UIColor.init(hexString: "#9C9B9B") , UIColor.init(hexString: "#C6C6C5")]
            self.bottomView.colors = [UIColor.init(hexString: "#F9B200") , UIColor.init(hexString: "#E63B11")]
            //self.cardView.applyGradient(colorOne: .init(hexString: "#9C9B9B"), ColorTwo: .init(hexString: "#C6C6C5"))
            //self.bottomView.applyGradient1(colorOne: .init(hexString: "#F9B200"), ColorTwo: .init(hexString: "#E63B11"))
            
        }
        topView.layer.cornerRadius = 20
        //cardView.layer.cornerRadius = 30.0
       // lblCode.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        //btnShare.titleLabel?.font = UIFont.systemFont(ofSize: 20.0)
    }
    

    @IBAction func onClickedResendCode(_ sender: UIButton) {
        delegate.resendCode(tag: sender.tag)
    }
    
    
    
    @IBAction func onClickedShareBtn(_ sender: UIButton) {
        delegate.shareCode(tag: sender.tag)
    } 
}
