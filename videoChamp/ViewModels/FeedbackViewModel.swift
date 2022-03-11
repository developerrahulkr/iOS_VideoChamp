//
//  FeedbackViewModel.swift
//  videoChamp
//
//  Created by iOS Developer on 22/02/22.
//

import Foundation
import UIKit


class FeedbackViewModel : NSObject {

    
    
    lazy var getFeedbackDataSource : [CMGetFeedbackData] = {
        let feedbackData = [CMGetFeedbackData]()
        return feedbackData
    }()
    
    lazy var getFeedbackDescriptionDataSource : [CMGetFeedbackDescriptionData] = {
        let feedbackData = [CMGetFeedbackDescriptionData]()
        return feedbackData
    }()
    
    lazy var giveFeedbackSection : [CMFeedBack] = {
        let sectionData = [CMFeedBack]()
        return sectionData
    }()
    
    lazy var getFeedbackServiceDataSource : [CMGetFeedbackServiceData] = {
       let datasource = [CMGetFeedbackServiceData]()
        return datasource
    }()
    
    
    func getFeedbackData(completionHandler : @escaping(Bool, Bool) -> ()) {
        UIApplication.topViewController()?.showActivityIndicator()
        
        APIManager.shared.getFeedback { inDict in
            UIApplication.topViewController()?.hideActivityIndicator()
            if inDict == nil {
                print("Directory is Empty")
            }else {
                
                let data = inDict!["data"].dictionary
                let userDetail = data?["user"]!.arrayValue
                let msg = inDict!["message"].stringValue
                let statusCode = inDict!["status"].stringValue
                
                if statusCode == "200"{
                    for dic in userDetail! {
                        self.getFeedbackDataSource.append(CMGetFeedbackData(title: dic["title"].stringValue , desc: dic["desc"].stringValue, time: dic["createdAt"].stringValue, _id: dic["_id"].stringValue))
                    }
                    print("\(msg)")
                    completionHandler(true, true)
                    if userDetail!.isEmpty {
                        print("User Is Empty! ")
                        completionHandler(true,false)
                    }
                }else{
                    print("Error Message : \(msg)")
                    completionHandler(false,false)
                }
            }
        }
    }
    
    func getSection(){
        let data1 = CMFeedBack(secTitle: "Title", secTitle2: "")
        giveFeedbackSection.append(data1)
        
        let data2 = CMFeedBack(secTitle: "Enter your email Id", secTitle2: "")
        giveFeedbackSection.append(data2)
        
        let data3 = CMFeedBack(secTitle: "", secTitle2: "")
        giveFeedbackSection.append(data3)
        
        let data4 = CMFeedBack(secTitle: "Attach Screenshots (Optional)", secTitle2: "")
        giveFeedbackSection.append(data4)
        let data5 = CMFeedBack(secTitle: "", secTitle2: "")
        giveFeedbackSection.append(data5)
    }
    
//    MARK: - Uplaod Data with Image
    func uploadFeedbackData(imageData : [Data?], feedBackData : CMPostFeedbackData, completionHandler : @escaping (Bool) -> Void) {
        
        let parameter = ["title" : feedBackData.title ?? "", "desc" : feedBackData.desc ?? "", "email" : feedBackData.email ?? "", "image" : feedBackData.image] as [String : Any]
        UIApplication.topViewController()?.showActivityIndicator()
        APIManager.shared.uploadPostData(imgData: imageData, parameter: parameter) { inDict in
            UIApplication.topViewController()?.hideActivityIndicator()
            if inDict == nil {
                UIApplication.topViewController()?.showAlert(alertMessage: "Directory is Empty")
                completionHandler(false)
            }else{
                let statusCode = inDict!["status"].stringValue
                let error_msg = inDict!["message"].stringValue
                if statusCode == "200"{
                    print("\(error_msg)")
                    completionHandler(true)
                }else{
                    completionHandler(false)
                    print("Error Msg : \(error_msg)")
                }
                
            }
        }
    }
    
    func getFeedbackListData(feedId : String, completionHandler : @escaping(Bool) -> ()) {
        UIApplication.topViewController()?.showActivityIndicator()
        
        APIManager.shared.getFeedbackData(feedID: feedId) { dict in
            UIApplication.topViewController()?.hideActivityIndicator()
            if dict == nil {
                UIApplication.topViewController()?.showAlert(alertMessage: "Directory is Empty")
            }else{
                let msg = dict!["message"].stringValue
                let statusCode = dict!["status"].stringValue
                let data = dict!["data"].dictionary
                let messageData = data!["messagelisting"]!.arrayValue
                
                let feedbackDetail = data!["feedbackDetail"]?.dictionary
                print(feedbackDetail!["desc"]!.stringValue)
                self.getFeedbackDescriptionDataSource.append(CMGetFeedbackDescriptionData(desc: feedbackDetail!["desc"]!.stringValue, createdAt: feedbackDetail!["createdAt"]!.stringValue))
//                self.getFeedbackServiceDataSource.append(CMGetFeedbackServiceData(message: "", type: "", createdAt: "", image: ""))
                
                if statusCode == "200" {
                    for dic in messageData {
                        self.getFeedbackServiceDataSource.append(CMGetFeedbackServiceData(message: dic["message"].stringValue, type: dic["type"].stringValue, createdAt: dic["createdAt"].stringValue, image: dic["image"].stringValue))

                    }
                    print("\(msg)")
                    completionHandler(true)
                }else{
                    print("error message : \(msg)")
                    completionHandler(false)
                }
                
            }
        }
    }
    
}
