//
//  GetNavBar.swift
//  videoChamp
//
//  Created by iOS Developer on 29/05/22.
//

import Foundation
import UIKit

extension UIApplication {
    class func getNavController() -> UINavigationController? {
        
        let controller = UIApplication.shared.keyWindow?.rootViewController
        if let navigationController = controller as? UINavigationController {
            return navigationController
        }
       return UINavigationController()
    }
    
   
}


