//
//  CommonUtiliies.swift
//  videoChamp
//
//  Created by iOS Developer on 16/02/22.
//

import Foundation
import UIKit

extension UIViewController {
    public func Log<T>(_ object: T?, filename: String = #file, line: Int = #line, funcname: String = #function) {
        #if DEBUG
            //guard let object = object else { return }
        print("***** Screen Detail : \(Date()) \(filename.components(separatedBy: "/").last ?? "") (line: \(line)) :: \(funcname) :: \(String(describing: object))")
        #endif
    }
    
    func upperCase(textField : String) -> String{
        let testString = textField.trimmingCharacters(in: .whitespaces)
        let lowerCase = CharacterSet.lowercaseLetters
        let upperCase = CharacterSet.uppercaseLetters
        var str = ""
        if testString.count == 0 {
            str =   ""
        }
        
        else if  testString.count == 1 {
            str =  String(testString.prefix(1))
           
        }
        
        else  {
            str =     String(testString.prefix(2))
            
//            str =   testString.firstCapitalized
//            str =   str.Capitalizedsec
        }
        
        
    
//        for currentCharacter in testString.unicodeScalars {
//            if lowerCase.contains(currentCharacter) {
//
//            } else if upperCase.contains(currentCharacter) {
//                str = str + "\(currentCharacter)"
//            } else {
//            }
//
//        }
        return str.uppercased()
    }
    
    
    
    func showAlert(alertMessage : String) {
        let alert = UIAlertController(title: appName, message: alertMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showExitAlert() {
        
        let alert = UIAlertController(title: "VideoChamp", message: "You are blocked from admin Please contact to admin", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "EXIT", style: .default) { _ in
            
            exit(0)
        }
        alert.addAction(okAction)
        self.present(alert, animated: true)
        self.showAlert(alertMessage: "User is Block")
        
    }
    
    
    
//    MARK: - Email Validation
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
//    func isValidName(userName : String) -> Bool {
//        let userNameregEx = "[A-Za-z]{3,18}"
//        let userNameStr = NSPredicate(format: "SELF MATCHES %@", userNameregEx)
//        return userNameStr.evaluate(with: userName)
//    }
    
    func isValidName(userName:String) -> Bool {
        guard userName.count > 3, userName.count < 18 else { return false }
        let predicateTest = NSPredicate(format: "SELF MATCHES %@", "^(([^ ]?)(^[a-zA-Z].*[a-zA-Z][0-9]$)([^ ]?))$")
        return predicateTest.evaluate(with: userName)
    }
    
    
    
    
    
//    MARK: Gradient Color
    
    func gradientColor(topColor : UIColor, bottomColor : UIColor)
    {
        let gradient = CAGradientLayer()
        gradient.frame = view.frame
        gradient.colors = [topColor.cgColor, bottomColor.cgColor]
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    func gradientThreeColor(topColor : UIColor, mediumColor : UIColor, bottomColor : UIColor){
        
        let gradient = CAGradientLayer()
        
        gradient.frame = view.bounds
        gradient.colors = [topColor.cgColor,mediumColor, bottomColor.cgColor]
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    func gradientfourColor(topColor : UIColor, mediumColor : UIColor, bottomMediumColor : UIColor, bottomColor : UIColor){
        
        let gradient = CAGradientLayer()
        
        gradient.frame = view.bounds
        gradient.colors = [topColor.cgColor, mediumColor.cgColor, bottomMediumColor.cgColor, bottomColor.cgColor]
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    
}


extension String {
    func boldAttributeString(boldStr : String) {
        let boldString = boldStr
        let normalStrins1 = "Your invite request to become"
        let normalString2 = "for the recipient is here"
        
        let attributedString1 = NSMutableAttributedString(string:normalStrins1)
        let attributeString2 = NSMutableAttributedString(string: normalString2)
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 21),NSAttributedString.Key.foregroundColor : UIColor.black]
        let BoldText = NSMutableAttributedString(string: boldString, attributes:attrs)
        BoldText.append(attributedString1)
        BoldText.append(attributeString2)
    }
}



extension StringProtocol {
    var firstUppercased: String { return prefix(1).uppercased() + dropFirst() }
    var firstCapitalized: String { return prefix(1).capitalized + dropFirst() }
        var Capitalizedsec: String { return prefix(2).capitalized + dropFirst()
        
    }
}


    extension String {
        func removingWhitespaces() -> String {
            return components(separatedBy: .whitespaces).joined()
        }
    }

extension UIView{
    func applyGradient(colorOne: UIColor, ColorTwo: UIColor) {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [colorOne.cgColor, ColorTwo.cgColor]
        gradient.locations = [0.0, 1.0]        
        layer.insertSublayer(gradient, at: 0)
    }
    
    func applyGradient2(frame: CGRect,colorOne: UIColor, ColorTwo: UIColor) {
        let gradient = CAGradientLayer()
        gradient.frame = frame
        
        gradient.colors = [colorOne.cgColor, ColorTwo.cgColor]
        gradient.locations = [0.0, 1.0] 
        layer.insertSublayer(gradient, at: 0)
    }
    func applyGradient1(colorOne: UIColor, ColorTwo: UIColor) {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        
        gradient.colors = [colorOne.cgColor, ColorTwo.cgColor]
        gradient.locations = [-2.0, 1.2]
        layer.insertSublayer(gradient, at: 0)
    }
    func applyGradientForInsta(colorOne: UIColor, ColorTwo: UIColor, ColorThree: UIColor)
    {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [colorOne.cgColor, ColorTwo.cgColor, ColorThree.cgColor]
//        gradient.locations = [0.0,0.0,1.1]
//        //gradient.startPoint = CGPoint(x: 0.3, y: 0.2)
//        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
//        // gradient.endPoint = CGPoint(x: 0.4, y: 0.9)
//        //        gradient.type = .axial
//        gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
        // gradient.cornerRadius = 10
        layer.insertSublayer(gradient, at: 0)
        self.clipsToBounds = true
        //self.layer.masksToBounds = false
    }
    
    func applyGradial(colorOne: UIColor, ColorTwo: UIColor) {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [colorOne.cgColor, ColorTwo.cgColor]
        gradient.locations = [ 0.0, 0.9 ]
//        gradient.startPoint = CGPoint(x: 0.5, y: 1.8)
//        gradient.endPoint = CGPoint(x: 0, y: 1)
        layer.insertSublayer(gradient, at: 0)
    }
    
}




public extension UIColor {

  convenience init(hexString: String) {
    let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int = UInt64()
    Scanner(string: hex).scanHexInt64(&int)
    let a, r, g, b: UInt64
    switch hex.count {
    case 3:
      (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
    case 6:
      (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
    case 8:
      (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
    default:
      (a, r, g, b) = (1, 1, 1, 0)
    }
    self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
  }

}
