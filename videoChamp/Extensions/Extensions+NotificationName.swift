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
    static let kNotificationReadSelection = Notification.Name("kNotificationReadSelection")
    static let kRefreshTableView = Notification.Name("kRefreshTableView")
    static let kCloseScreen = Notification.Name("kCloseScreen")
    static let kDisconnect = Notification.Name("kDisconnect")

    static let kPopToRoot = Notification.Name("kPopToRoot")
    static let kAvatarKey = Notification.Name("kAvatarKey")
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
    
    func    roundRightChatCorner(cornerRadius : Double){
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

extension UIViewController {
    
    func showToast(message : String, font: UIFont) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 100, y: self.view.frame.size.height-100, width: 250, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 0.4, delay: 0.4, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
}


