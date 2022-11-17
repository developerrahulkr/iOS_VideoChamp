//
//  TermsAndConditionVC.swift
//  videoChamp
//
//  Created by iOS Developer on 16/02/22.
//
import GradientView
import UIKit
import WebKit

class TermsAndConditionVC: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblTermAndCondition: UILabel!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var viewMain: GradientView!
    
    let cellID = "TermsAndConditionsCell"
    
    let termVM = GenerateNumberViewModel()
    var termsAndConditions = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.viewTop.applyGradient1(colorOne: .init(hexString: "#F9B200"), ColorTwo: .init(hexString: "#E63B11"))
        }
//        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
//        tableView.delegate = self
//        tableView.dataSource = self
        
        //lblTermAndCondition.font = UIFont.systemFont(ofSize: 17.0, weight: .bold)
        loadData()
    }
    override func viewDidLayoutSubviews() {
        viewMain.colors = [UIColor.init(hexString: "#9C9B9B"),UIColor(hexString: "#C6C6C5")]
    }
    
    func loadData(){
        termVM.termAndConditionsData { [weak self] isSuccess, termData,blockCode  in
            guard let self = self else {return}
            if isSuccess && blockCode == "10" {
                self.showExitAlert()
            }else{
                if isSuccess {
                    self.termsAndConditions = termData
                    let content = "<html><body><p><font size=30>" + self.termsAndConditions + "</font></p></body></html>"
                    self.webView.loadHTMLString(content, baseURL: nil)
                   // self.tableView.reloadData()
                    
                }else{
                    self.showAlert(alertMessage: "Data is Empty!")
                }
            }
            
        }
    }
    
  

    @IBAction func onClickedBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

//extension TermsAndConditionVC : UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! TermsAndConditionsCell
//        print(termsAndConditions)
//   // let html = stringFromHTML(string: termsAndConditions)
//       // cell.webView.loadHTMLString(termsAndConditions, baseURL: nil)
//        return cell
//    }
//}




