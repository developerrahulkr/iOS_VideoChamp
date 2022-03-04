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
        let testString = textField
        let lowerCase = CharacterSet.lowercaseLetters
        let upperCase = CharacterSet.uppercaseLetters
        var str = ""

        for currentCharacter in testString.unicodeScalars {
            if lowerCase.contains(currentCharacter) {
                
            } else if upperCase.contains(currentCharacter) {
                str = str + "\(currentCharacter)"
            } else {
            }
            
        }
        return str
    }
    
    
    
    func showAlert(alertMessage : String) {
        let alert = UIAlertController(title: appName, message: alertMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
//    MARK: Gradient Color
    
    func gradientColor(topColor : UIColor, bottomColor : UIColor){
        
        let gradient = CAGradientLayer()
        
        gradient.frame = view.bounds
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


