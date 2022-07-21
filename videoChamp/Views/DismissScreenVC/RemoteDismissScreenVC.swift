//
//  RemoteDismissScreenVC.swift
//  videoChamp
//
//  Created by Akshay_mac on 23/06/22.
//

import UIKit

class RemoteDismissScreenVC: UIViewController {

    @IBOutlet weak var btnOK: UIButton!
    @IBOutlet weak var lblText: UILabel!
    
    @IBOutlet weak var cardView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
            self.dismiss(animated: true)
        }
    }
    override func viewDidLayoutSubviews() {
        btnOK.layer.cornerRadius = btnOK.bounds.height/2
        cardView.layer.cornerRadius = 15.0
    }
    @IBAction func onClickedOKBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}
