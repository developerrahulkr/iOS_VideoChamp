//
//  CameraCodeCell2.swift
//  videoChamp
//
//  Created by iOS Developer on 18/02/22.
//

import UIKit

protocol CameraCodeDelegate {
    func resendCode(tag : Int)
    func shareCode(tag : Int)
}

class CameraCodeCell2: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var lblCode: UILabel!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnResend: UIButton!
    
    var delegate : CameraCodeDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        topView.layer.cornerRadius = topView.bounds.height/2
        bottomView.layer.cornerRadius = bottomView.bounds.height/2
        cardView.layer.cornerRadius = 30.0
        lblCode.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
    }

    @IBAction func onClickedResendCode(_ sender: UIButton) {
        delegate.resendCode(tag: sender.tag)
    }
    
    
    
    @IBAction func onClickedShareBtn(_ sender: UIButton) {
        delegate.shareCode(tag: sender.tag)
    } 
}
