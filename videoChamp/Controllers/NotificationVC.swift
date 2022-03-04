//
//  NotificationVC.swift
//  videoChamp
//
//  Created by iOS Developer on 16/02/22.
//

import UIKit

class NotificationVC: UIViewController {

    @IBOutlet weak var lblNotification: UILabel!
    
    @IBOutlet weak var notificationTableView: UITableView!
    
    let cellID = "NotificationCell"
    
    let notificationViewModel = NotificationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        notificationTableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
        loadData()
        self.gradientColor(topColor: lightWhite, bottomColor: lightgrey)
        
    }
    
    
    func loadData() {
        notificationViewModel.getNotificationData { [weak self] isRunningStatus, isNotificationEmpty in
            guard let self = self else {return}
            
            if isRunningStatus && isNotificationEmpty {
                self.notificationTableView.reloadData()
            }
            
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        lblNotification.font = UIFont.systemFont(ofSize: 17.0, weight: .bold)
    }
    
    @IBAction func onClickedBackBTn(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - TableView Delegate

extension NotificationVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationViewModel.getNotificationDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! NotificationCell
        cell.updateData(inData: notificationViewModel.getNotificationDataSource[indexPath.row])
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in

//            self.arr.remove(at: indexPath.row)
            self.notificationViewModel.getNotificationDataSource.remove(at: indexPath.row)
            self.notificationTableView.deleteRows(at: [indexPath], with: .fade)
            self.notificationTableView.reloadData()
            completionHandler(true)
        }
        deleteAction.image = UIImage(named: "trash_icon")
        deleteAction.backgroundColor = .clear
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}
