//
//  PrivacyPolicyVC.swift
//  videoChamp
//
//  Created by Udit_Rajput_Mac on 13/10/22.
//

import UIKit
import GradientView
import WebKit


class PrivacyPolicyVC: UIViewController {
    @IBOutlet weak var ViewTop: UIView!
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var bottomView: GradientView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 , execute:  {
            self.ViewTop.applyGradient1(colorOne: .init(hexString: "#F9B200"), ColorTwo: .init(hexString: "#E63B11"))
            //self.webView.applyGradient1(colorOne: .init(hexString: "#F9B200"), ColorTwo: .init(hexString: "#E63B11"))
//            let url = URL (string: "http://3.12.253.202/videochamp_web_build/privacyPolicy.html")
//            let requestObj = URLRequest(url: url!)
            
            let url = URL(string: "http://3.12.253.202/videochamp_web_build/privacyPolicy.html")
            self.webView.load(URLRequest(url: url!))
          //  self.webView.load(requestObj)
        })

      
    }
    
    override func viewDidLayoutSubviews() {
        bottomView.colors = [UIColor.init(hexString: "#9C9B9B"),UIColor(hexString: "#C6C6C5")]

    }
    

    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
