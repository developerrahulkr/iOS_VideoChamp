//
//  ProgressBar.swift
//  videoChamp
//
//  Created by iOS Developer on 23/02/22.
//

import Foundation
import ProgressHUD

import UIKit


class ProgressBar : NSObject {
    
    static let shared = ProgressBar()
    
    
    func showProgressbar(){
        ProgressHUD.show()
        ProgressHUD.animationType = .multipleCirclePulse
        ProgressHUD.colorAnimation = .blue
    }
    
    func hideProgressBar(){
        ProgressHUD.dismiss()
    }
}
