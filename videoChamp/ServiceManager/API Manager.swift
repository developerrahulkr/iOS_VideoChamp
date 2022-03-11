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
    func getUser(userName : String, deviceToken : String,  completionHandler : @escaping(_ dict : JSON?) -> Void) {
//        let header : HTTPHeaders = [.contentType("application/json")]
        let param = ["name" : userName, "deviceToken" : deviceToken, "deviceType" : "\(UIDevice.current.systemName)", "deviceId" : "\(UIDevice.current.name)"]
        
        print("device Model and name : \(UIDevice.current.name) \(String(describing: UIDevice.current.model))")
        print("\(UIDevice.current.model)")
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
    
    
//    MARK: - Post feedback Message
    
    func postFeedbackMessageData(imgData : Data?, parameter : [String : Any], completionHandler : ((_ inDict : JSON?) -> Void)? = nil ) {
        let header: HTTPHeaders = [.authorization(bearerToken: Utility.shared.getUserAppToken())]

        AF.upload(multipartFormData: { MultipartFormData in
            if imgData?.isEmpty == nil {
//                UIApplication.topViewController()?.showAlert(alertMessage: "Please Upload Image!")
                print("image is Not Uploaded!")
            }else{
                MultipartFormData.append(imgData!, withName: "image", fileName: "filename.png", mimeType: "image/png")
            }
            for (key, value) in parameter {
                MultipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: feedback_message_url, method: .post, headers: header).response { (response) in
            print(response)
            if let err = response.error {
                print("error : \(err)")
                return
            }
            
            print("Successfully uploaded")
            let json = response.data
            if json != nil {
                let jsonObject = JSON(json!)
                print(jsonObject)
                completionHandler!(jsonObject)
            }
        }
        
    }

    
    //    MARK: - read Notification
        
    func readNotification(notificationId : String, completionHandler : @escaping(_ dict : JSON?) -> Void){
        let param = ["notificationId" : notificationId]
        let header: HTTPHeaders = [.authorization(bearerToken: Utility.shared.getUserAppToken())]
        AF.request(read_notification_url, method: .post, parameters: param, encoder: JSONParameterEncoder.default, headers: header).response {
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
    
//  MARK: - delete Notification
    
    func deleteNotification(notificationId : String, completionHandler : @escaping(_ dict : JSON?) -> Void) {
        let param = ["notificationId" : notificationId]
        let header: HTTPHeaders = [.authorization(bearerToken: Utility.shared.getUserAppToken())]
        AF.request(delete_notification_url, method: .post, parameters: param, encoder: JSONParameterEncoder.default, headers: header).response {
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
        let header: HTTPHeaders = [.authorization(bearerToken: Utility.shared.getUserAppToken())]
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
    
    
//    MARK: - Get All Notification
    
    func getNotification(completionHandler : @escaping(_ dict : JSON?) -> Void) {
        let header: HTTPHeaders = [.authorization(bearerToken: Utility.shared.getUserAppToken())]
        AF.request(notification_url, method: .get, headers: header).response {
            (response) in
            print(response)
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
    
    

    
    
//    MARK: GetFeedback Message Data

    func getFeedbackData(feedID : String, completionHandler : @escaping(_ dict : JSON?) -> Void) {
        let header: HTTPHeaders = [.authorization(bearerToken: Utility.shared.getUserAppToken())]
        let feedback_list_url = "\(message_list_url)\(feedID)"
        AF.request(feedback_list_url, method: .get, parameters: nil, headers: header).response {
            (response) in
            print(response)
            switch response.result {
                
            case .success(let data):
                do {
                    _ = try JSONSerialization.jsonObject(with: data!, options: [])
                    let jsonData = try? JSON(data: response.data!)
                    print("All Data : \(jsonData)")
                    completionHandler(jsonData)
                }catch (let err) {
                    print(err.localizedDescription)
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
        
    }
    
    
    
    
//    MARK: Post Message Data
    
    
    
    func uploadPostData(imgData : [Data?], parameter : [String : Any], completionHandler : ((_ inDict : JSON?) -> Void)? = nil ) {
        let header: HTTPHeaders = [.authorization(bearerToken: Utility.shared.getUserAppToken())]

        AF.upload(multipartFormData: { MultipartFormData in
            if imgData.count == 0 {
                UIApplication.topViewController()?.showAlert(alertMessage: "Please Upload Image!")
            }else{
                for imageData in imgData {
                    MultipartFormData.append(imageData!, withName: "image", fileName: "filename.png", mimeType: "image/png")
                }
                
            }
            for (key, value) in parameter {
                MultipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: post_feedback_url, method: .post, headers: header).response { (response) in
            print(response)
            
            if let err = response.error {
                print("error : \(err)")
                return
            }
            
            print("Successfully uploaded")
            let json = response.data
            if json != nil {
                let jsonObject = JSON(json!)
                print(jsonObject)
                completionHandler!(jsonObject)
            }
        }
        
    }
    
    
}
