//
//  Extensions+NotificationName.swift
//  videoChamp
//
//  Created by iOS Developer on 16/02/22.
//

import Foundation
import UIKit

extension Notification.Name {
    
    static let kNotification = Notification.Name("kNotification")
    static let kFeedback = Notification.Name("kFeedback")
    static let kTermsAndConditions = Notification.Name("kTermsAndConditions")
    static let kShare = Notification.Name("kShare")
    static let refreshFeedbackData = Notification.Name("refreshFeedbackData")
}


extension UIView {
    func circleView(){
        self.layer.cornerRadius = self.bounds.height/2
    }
    
    func roundLeftChatCorner(cornerRadius : Double){
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.clipsToBounds = true
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
    }
    
    func roundRightChatCorner(cornerRadius : Double){
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.clipsToBounds = true
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner]
    }
    
}
extension UIApplication
{

    class func topViewController(base: UIViewController? = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController) -> UIViewController?
    {
        if let nav = base as? UINavigationController
        {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController
        {
            if let selected = tab.selectedViewController
            {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController
        {
            return topViewController(base: presented)
        }
        return base
    }
}


