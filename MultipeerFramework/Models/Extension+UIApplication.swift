//
//  Extension+UIApplication.swift
//  videoChamp
//
//  Created by iOS Developer on 01/06/22.
//

import Foundation
import UIKit

extension UIApplication
{

    class func mcTopViewController(base: UIViewController? = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController) -> UIViewController?
    {
        if let nav = base as? UINavigationController
        {
            return mcTopViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController
        {
            if let selected = tab.selectedViewController
            {
                return mcTopViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController
        {
            return mcTopViewController(base: presented)
        }
        return base
    }
}
