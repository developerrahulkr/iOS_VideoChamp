//
//  GenerateLinkViewModel.swift
//  videoChamp
//
//  Created by iOS Developer on 24/05/22.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON


class GeneratedLinkViewModel {
    
    
    func linkGenerated(cmGenerateLinkData : CMGenerateLink, completionHandler : @escaping(Bool, String, String, String) -> Void){
        
        UIApplication.topViewController()?.showActivityIndicator()
        APIManager.shared.generateLink(data: cmGenerateLinkData) { dict in
            UIApplication.topViewController()?.hideActivityIndicator()
            if dict != nil {
                let statusCode = dict!["status"].stringValue
                let error_msg = dict!["message"].stringValue
                let url = dict!["data"]["url"].stringValue
                let urlCode = dict!["data"]["code"].stringValue
                if statusCode == "200" {
                    print("URL IS : \(url), /n code \(urlCode)")
                    print("GEnerate Link Message : \(error_msg)")
                    completionHandler(true,url,urlCode,error_msg)
                }else{
                    print("error Message : \(error_msg)")
                    completionHandler(false, url,error_msg,error_msg)
                }
                
            }else{
                print("Directory is Empty...")
            }
            
        }
    }

}
