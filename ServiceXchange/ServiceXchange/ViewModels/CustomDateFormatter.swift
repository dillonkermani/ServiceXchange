//
//  CustomDateFormatter.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 3/5/23.
//

import Foundation

class CustomDateFormatter: ObservableObject {
    private let dateFormatter = DateFormatter()
    
    // From Date to Timestamp
    func formatDate(_ date: Date, format: String) -> String {
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    // From Timestamp to Date
    func formatTimestamp(_ timestamp: Double, format: String) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        return formatDate(date, format: format)
    }
    
    // Formatted time since timestamp.
    func formatTimestampSince(_ timestamp: Double) -> String {
        let interval = Date().timeIntervalSince1970 - timestamp
        
        if interval < 60 {
            return "just now"
        } else if interval < 3600 {
            let minutes = Int(interval / 60)
            return "\(minutes) minutes ago"
        } else if interval < 86400 {
            let hours = Int(interval / 3600)
            return "\(hours) hours ago"
        } else {
            dateFormatter.dateFormat = "MMM d, yyyy"
            let date = Date(timeIntervalSince1970: timestamp)
            return dateFormatter.string(from: date)
        }
    }
}




