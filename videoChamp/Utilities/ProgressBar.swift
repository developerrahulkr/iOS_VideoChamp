//
//  ProgressBar.swift
//  videoChamp
//
//  Created by iOS Developer on 23/02/22.
//

import Foundation
import ProgressHUD
import SystemConfiguration
import UIKit


extension UIViewController {
    func showActivityIndicator() {
        let backgroundview = UIView.init(frame: CGRect.init(x: 0, y: 0, width:  view.frame.size.width, height:  view.frame.size.height))
        backgroundview.tag=1024;
        backgroundview.backgroundColor = UIColor.init(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 0.4)
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        actInd.center = self.view.center
        actInd.style = UIActivityIndicatorView.Style.whiteLarge
        actInd.color = UIColor.red
        actInd.startAnimating()
        backgroundview.addSubview(actInd)
        view.addSubview(backgroundview)
    }

    func hideActivityIndicator() {
        view.viewWithTag(1024)?.removeFromSuperview()
    }
}
