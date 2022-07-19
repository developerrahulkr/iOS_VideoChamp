//
//  DismissAlertVC.swift
//  videoChamp
//
//  Created by Akshay_mac on 18/07/22.
//

import UIKit

class DismissAlertVC: UIViewController {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var btnOK: UIButton!
    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var btnCheck: UIButton!
    var isBack : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        btnNo.layer.cornerRadius = btnNo.bounds.height / 2
        btnOK.layer.cornerRadius = btnOK.bounds.height / 2
        cardView.layer.cornerRadius = 10.0
    }
    
    @IBAction func onClickedCheckBtn(_ sender: UIButton) {
        
        if sender.image(for: .normal) == UIImage(systemName: "square") {
            sender.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            UserDefaults.standard.set("true", forKey: "isCheck")
        }else{
            sender.setImage(UIImage(systemName: "square"), for: .normal)
            UserDefaults.standard.set("false", forKey: "isCheck")
        }
    }
    
    @IBAction func onClickedCloseBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func onClickedOKBtn(_ sender: UIButton) {
        if self.isBack {
            self.dismiss(animated: true)
            NotificationCenter.default.post(name: .kCloseScreen, object: nil)
        }
        
    }
    
    @IBAction func onClickedNoBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    

    
//    checkmark.square.fill


}
