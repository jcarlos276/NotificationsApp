//
//  String + Helpers.swift
//  NotificationApp
//
//  Created by Juan Carlos Guillén Castro on 7/25/19.
//  Copyright © 2019 Juan Carlos Guillén Castro. All rights reserved.
//

import Foundation

extension String {
    func stringToDate(format:String = "yyyy-MM-dd") -> Date? {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Locale(identifier: "es_PE")
        
        return dateFormatter.date(from: self)
    }
}

extension Date {
    func dateToString(format:String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        
        formatter.locale = Locale(identifier: "es_PE")
        formatter.dateFormat = format
        
        return formatter.string(from: self)
    }
}
