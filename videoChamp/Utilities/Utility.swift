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
    
    
    
    func timeConvertor(string: String) -> String
    {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // This formate is input formated .
        
        if let _ = dateFormatter.date(from: "\(string)") {
            //date parsing succeeded, if you need to do additional logic, replace _ with some variable name i.e date
            let formateDate = dateFormatter.date(from:"\(string)")!
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: formateDate)
        } else {
            // Invalid date
            return string
        }
    }
    
    
    func timeFormatConvertor(string: String) -> String
    {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // This formate is input formated .
        
        if let _ = dateFormatter.date(from: "\(string)") {
            //date parsing succeeded, if you need to do additional logic, replace _ with some variable name i.e date
            let formateDate = dateFormatter.date(from:"\(string)")!
            dateFormatter.dateFormat = "hh:mm a"
            return dateFormatter.string(from: formateDate)
        } else {
            // Invalid date
            return string
        }
    }
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
    @available(iOS, deprecated: 9.0)
    func imageForKey(key: String) -> UIImage? {
        var image: UIImage?
        
        if let imageData = data(forKey: key) {
            image = NSKeyedUnarchiver.unarchiveObject(with: imageData) as? UIImage
        }
        return image
    }
    
    @available(iOS, deprecated: 9.0)
    func setImage(image: UIImage?, forKey key: String) {
        var imageData: NSData?
        if let image = image {
            imageData = NSKeyedArchiver.archivedData(withRootObject: image) as NSData?
        }
        set(imageData, forKey: key)
    }
    
    
    

}
