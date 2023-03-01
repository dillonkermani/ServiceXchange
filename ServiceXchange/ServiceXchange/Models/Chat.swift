//
//  Chat.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 2/28/23.
//

import Foundation

struct Chat: Identifiable, Codable {
    var id: String
    var createdAt: Double
    var createdBy: String
    var lastUpdated: Double
    var members: [String]
}
