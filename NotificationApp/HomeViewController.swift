//
//  ViewController.swift
//  NotificationApp
//
//  Created by Juan Carlos Guillén Castro on 7/24/19.
//  Copyright © 2019 Juan Carlos Guillén Castro. All rights reserved.
//

import UIKit
import RealmSwift
import Toast_Swift

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var fcmTokenBtn: UIButton!
    var notifications: [NotificationModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureContent()
        loadContent()
    }
    
    @objc func loadContent() {
        notifications = Array(realm.objects(NotificationModel.self))
        fcmTokenBtn.setTitle(UserDefaults.standard.object(forKey: "FCMToken") as? String ?? "", for: .normal)
    }
    
    func configureContent() {
        tableView.delegate = self
        tableView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(loadContent), name: Notification.Name.init("newNotification"), object: nil)
        fcmTokenBtn.titleLabel?.numberOfLines = 0
        fcmTokenBtn.titleLabel?.textAlignment = .center
    }

    func showDetail(ofNotification notification: NotificationModel) {
        performSegue(withIdentifier: "NotificationDetailViewController", sender: notification)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NotificationDetailViewController" {
            let vc = segue.destination as! NotificationDetailViewController
            vc.notification = sender as! NotificationModel
        }
    }
    
    @IBAction func copyFcmToken(_ sender: UIButton) {
        UIPasteboard.general.string = sender.titleLabel!.text ?? ""
        print("📍 TEXT COPIED: \(UIPasteboard.general.string ?? "")")
        self.view.makeToast("FcmToken copiado en el portapapeles")
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell") as! NotificationTableViewCell
        cell.notification = notifications[indexPath.row]
        cell.loadData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! NotificationTableViewCell
        showDetail(ofNotification: cell.notification)
    }
}

