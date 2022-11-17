//
//  Indicator.swift
//  videoChamp
//
//  Created by Udit_Rajput_Mac on 22/09/22.
//

import Foundation
import UIKit
import NVActivityIndicatorView
 
class Indicator: UIViewController , NVActivityIndicatorViewable {
    
    
    static let instance = Indicator()

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    func show(loadingText:String) {
        let size = CGSize(width: 50, height: 50)
        

        startAnimating(size, message: "Please wait for Connection",messageFont: .systemFont(ofSize: 18, weight: .regular), type: .lineScalePulseOutRapid, color: #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), backgroundColor: UIColor.lightGray.withAlphaComponent(0.3), textColor: .black)
        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
//            NVActivityIndicatorPresenter.sharedInstance.setMessage("please wait...")
//        }
    }

    func hide() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            self.stopAnimating()
        }
    }

}
