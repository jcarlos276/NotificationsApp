//
//  Notification.swift
//  NotificationApp
//
//  Created by Juan Carlos Guillén Castro on 7/24/19.
//  Copyright © 2019 Juan Carlos Guillén Castro. All rights reserved.
//

import Foundation
import RealmSwift

class NotificationModel: Object {
    @objc dynamic var id = 0
    @objc dynamic var createdAt = ""
    @objc dynamic var title = ""
    @objc dynamic var userInfo = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    func set(withUserInfo userInfo: [AnyHashable : Any]) {
        self.id = userInfo["gcm.message_id"] as? Int ?? autoIncrementId()
        self.createdAt = Date().dateToString(format: "hh:mm:ss dd-MM-yyyy")
        self.title = ""
        self.userInfo = "\(userInfo)"
        if let notificationDictionary = userInfo["aps"] as? [String: AnyObject] {
            if let alertDictionary = notificationDictionary["alert"] as? [String: AnyObject] {
                self.title = alertDictionary["title"] as? String ?? ""
            } else {
                print("🚮 HERE WITH NO CODE")
            }
        }
    }
    
    func autoIncrementId() -> Int {
        let realm = try! Realm()
        let lastNotification = realm.objects(NotificationModel.self).last ?? NotificationModel()
        return lastNotification.id + 1
    }
}
