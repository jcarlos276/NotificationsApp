//
//  NotificationTableViewCell.swift
//  NotificationApp
//
//  Created by Juan Carlos Guillén Castro on 7/24/19.
//  Copyright © 2019 Juan Carlos Guillén Castro. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    var notification = NotificationModel()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func loadData() {
        titleLbl.text = notification.title
        messageLbl.text = notification.userInfo
        dateLbl.text = notification.createdAt
    }

}
