//
//  FeedbackViewModel.swift
//  videoChamp
//
//  Created by iOS Developer on 22/02/22.
//

import Foundation


class FeedbackViewModel : NSObject {
    
//    lazy var feedbackDataSource : [CMNotification] = {
//        let feedbackData = [CMNotification]()
//        return feedbackData
//    }()
    
    
    lazy var getFeedbackDataSource : [CMGetFeedbackData] = {
        let feedbackData = [CMGetFeedbackData]()
        return feedbackData
    }()
    
    lazy var giveFeedbackSection : [CMFeedBack] = {
        let sectionData = [CMFeedBack]()
        return sectionData
    }()
    
//    func getFeedbackData(){
//        let data1 = CMNotification(title: "Network error", desc: "Banjo tote bag bicycle rights, High Life is has it ha sartorial cray craft beer whatever street art fapth.")
//        feedbackDataSource.append(data1)
//
//        let data2 = CMNotification(title: "Could not connect the device", desc: "Banjo tote bag bicycle rights, High Life is has it ha sartorial cray craft beer whatever street art fapth.")
//        feedbackDataSource.append(data2)
//
//        let data3 = CMNotification(title: "Network error", desc: "Banjo tote bag bicycle rights, High Life is has it ha sartorial cray craft beer whatever street art fapth.")
//        feedbackDataSource.append(data3)
//
//        let data4 = CMNotification(title: "Device is not supported", desc: "Banjo tote bag bicycle rights, High Life is has it ha sartorial cray craft beer whatever street art fapth.")
//        feedbackDataSource.append(data4)
//
//        let data5 = CMNotification(title: "Network error", desc: "Banjo tote bag bicycle rights, High Life is has it ha sartorial cray craft beer whatever street art fapth.")
//        feedbackDataSource.append(data5)
//
//        let data6 = CMNotification(title: "Poor connection", desc: "Banjo tote bag bicycle rights, High Life is has it ha sartorial cray craft beer whatever street art fapth.")
//        feedbackDataSource.append(data6)
//
//        let data7 = CMNotification(title: "Network error", desc: "Banjo tote bag bicycle rights, High Life is has it ha sartorial cray craft beer whatever street art fapth.")
//        feedbackDataSource.append(data7)
//
//    }
    
    
    func getFeedbackData(completionHandler : @escaping(Bool, Bool) -> ()) {
        ProgressBar.shared.showProgressbar()
        
        APIManager.shared.getFeedback { inDict in
            ProgressBar.shared.hideProgressBar()
            if inDict == nil {
                print("Directory is Empty")
            }else {
                
                let data = inDict!["data"].dictionary
                let userDetail = data!["user"]!.arrayValue
                let msg = inDict!["message"].stringValue
                let statusCode = inDict!["status"].stringValue
                
                if statusCode == "200"{
                    for dic in userDetail {
                        self.getFeedbackDataSource.append(CMGetFeedbackData(title: dic["title"].stringValue , desc: dic["desc"].stringValue, time: dic["createdAt"].stringValue))
                    }
                    print("\(msg)")
                    completionHandler(true, true)
                    if userDetail.isEmpty {
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
        
        let data2 = CMFeedBack(secTitle: "Enter your email Id (Optional)", secTitle2: "")
        giveFeedbackSection.append(data2)
        
        let data3 = CMFeedBack(secTitle: "Please do share your feedback", secTitle2: "0/1000")
        giveFeedbackSection.append(data3)
        
        let data4 = CMFeedBack(secTitle: "Attach Screenshots (Optional)", secTitle2: "")
        giveFeedbackSection.append(data4)
    }
    
}
