//
//  FeedbackVC.swift
//  videoChamp
//
//  Created by iOS Developer on 16/02/22.
//

import UIKit
import GradientView
class FeedbackVC: UIViewController {

    @IBOutlet weak var lblFeedback: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var viewMain: GradientView!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var btnFeedBack: UIButton!
    
    
    let feedbackVM = FeedbackViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnFeedBack.clipsToBounds = true
        btnFeedBack.layer.cornerRadius = 22
        
        tableView.register(UINib(nibName: "NotificationCell", bundle: nil), forCellReuseIdentifier: "NotificationCell")
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: .refreshFeedbackData, object: nil)
        DispatchQueue.main.async {
            self.viewTop.applyGradient1(colorOne: .init(hexString: "#F9B200"), ColorTwo: .init(hexString: "#E63B11"))
            self.btnFeedBack.applyGradient1(colorOne: .init(hexString: "#F9B200"), ColorTwo: .init(hexString: "#E63B11"))
        }
        loadData()
    }
    
    override func viewDidLayoutSubviews() {
        viewMain.colors = [UIColor.init(hexString: "#9C9B9B"),UIColor(hexString: "#C6C6C5")]
    }
    
    @objc func refreshData(){
        UIApplication.topViewController()?.showActivityIndicator()
        self.view.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            UIApplication.topViewController()?.hideActivityIndicator()
            self.view.isUserInteractionEnabled = true
            self.feedbackVM.getFeedbackDataSource.removeAll()
            self.loadData()
        } 
    }

    func loadData(){
        feedbackVM.getFeedbackData { [weak self] isStatusRunning, isUserEmpty  in
            guard let self = self else {return}
            if isStatusRunning && isUserEmpty {
                self.tableView.isHidden = false
                self.stackView.isHidden = true
                self.tableView.reloadData()
            }else if isStatusRunning && !isUserEmpty {
                self.tableView.isHidden = true
                self.stackView.isHidden = false
            }
        }
        
        lblFeedback.font = UIFont.systemFont(ofSize: 17.0, weight: .bold)
        
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .refreshFeedbackData, object: nil)
    }
    
    @IBAction func onClickedBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickedBtnFeedback(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GiveFeedbackVC") as! GiveFeedbackVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension FeedbackVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedbackVM.getFeedbackDataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        cell.updateFeedbackData(inData: feedbackVM.getFeedbackDataSource[indexPath.row])
        cell.lblNotification.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if AppUtility.lockOrientation(.all) == AppUtility.lockOrientation(.portrait) {
            self.tableView.reloadData()
        }else if AppUtility.lockOrientation(.all) == AppUtility.lockOrientation(.landscape) {
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FeedbackServiceVC") as! FeedbackServiceVC
        vc.feed_id = feedbackVM.getFeedbackDataSource[indexPath.row]._id ?? ""
        vc.lblTitleText = feedbackVM.getFeedbackDataSource[indexPath.row].title ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

