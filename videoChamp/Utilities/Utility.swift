//
//  Utility.swift
//  videoChamp
//
//  Created by iOS Developer on 24/02/22.
//

import Foundation
import UIKit

class Utility : NSObject {
    static let shared = Utility()
    
    func getUserAppToken() -> String {
        let token = UserDefaults.standard.string(forKey: "Apptoken")
        if let utoken = token{
            return utoken
        }
        return ""
    }
    
    
    func checkIsUserRegister() -> String {
        let userName = UserDefaults.standard.string(forKey: "isUserRegister")
        if let uRegister = userName {
            return uRegister
        }
        return ""
    }
    
//    func checkUserTextColor() -> UIColor {
//        
//        if let uColor = userTextColor {
//            return uColor
//        }
//        return .red
//    }
}

extension UserDefaults {

    func color(forKey key: String) -> UIColor? {

        guard let colorData = data(forKey: key) else { return nil }

        do {
            return try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData)
        } catch let error {
            print("color error \(error.localizedDescription)")
            return nil
        }

    }

    func set(_ value: UIColor?, forKey key: String) {

        guard let color = value else { return }
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
            set(data, forKey: key)
        } catch let error {
            print("error color key data not saved \(error.localizedDescription)")
        }

    }

}
