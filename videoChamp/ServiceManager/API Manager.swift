//
//  API Manager.swift
//  videoChamp
//
//  Created by iOS Developer on 23/02/22.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIManager : NSObject {
    
    static let shared = APIManager()
    
    
    func getUser(userName : String, completionHandler : @escaping(_ dict : JSON?) -> Void) {
//        let header : HTTPHeaders = [.contentType("application/json")]
        let param = ["name" : userName]
        AF.request(register_url, method: .post, parameters: param, encoder: JSONParameterEncoder.default, headers: nil).response {
            (response) in
            switch response.result {
            case .success(let data) :
                do {
                    _ = try JSONSerialization.jsonObject(with: data!, options: [])
                    let jsonData = try? JSON(data: response.data!)
                    completionHandler(jsonData)
                }catch {
                    print(error.localizedDescription)
                }
            case .failure(let err) :
                print("Error : \(err.localizedDescription)")
            }
        
            
        }
        
    }
    
    
//    MARK: - Get Feedback Data
    
    func getFeedback(completionHandler : @escaping(_ dict : JSON?) -> Void) {
        let header: HTTPHeaders = [.authorization(bearerToken: Utility.shared.getUserAppToken())
            
        ]
        AF.request(get_feedback_url, method: .get, headers: header).response { (response) in
            switch response.result {
                
            case .success(let data):
                do {
                    _ = try JSONSerialization.jsonObject(with: data!, options: [])
                    let jsonData = try? JSON(data: response.data!)
                    completionHandler(jsonData)
                    
                }catch (let err) {
                    print(err.localizedDescription)
                }
            case .failure(let err):
                print(err.localizedDescription)
            } 
        }
    }
    
}
