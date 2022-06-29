//
//  AlertCameraVC.swift
//  videoChamp
//
//  Created by iOS Developer on 31/05/22.
//

import UIKit

class AlertCameraVC: UIViewController {

    @IBOutlet weak var viewAlert: UIView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var btnOK: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    
    var image = UIImage()
    var titleText = ""
    var messageText = ""
    var btnColor = UIColor()
    var btnOkText = "OK"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        btnOK.backgroundColor = btnColor
        lblTitle.text = titleText
        lblMsg.text = messageText
        imgView.image = image
        if btnOkText.isEmpty {
            
        }else{
            btnOK.setTitle(btnOkText, for: .normal)
        }
        
        
    }

    override func viewDidLayoutSubviews() {
        btnOK.layer.cornerRadius = btnOK.bounds.height / 2
        lblMsg.font = UIFont.systemFont(ofSize: 10.0, weight: .ultraLight)
        lblTitle.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        viewAlert.layer.cornerRadius = 10.0
    }
    
    @IBAction func onClickedOKBtn(_ sender: UIButton) {
        if btnOkText.isEmpty {
            self.dismiss(animated: true)
        }else{
            self.dismiss(animated: true)
            NotificationCenter.default.post(name: .kDisconnect, object: nil)
        }
        
        
        
    }
}
