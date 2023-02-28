//
//  Model.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 2/26/23.
//

import Foundation

struct Message: Identifiable, Codable {
    var id: String
    var fromUser: String
    var text: String
    var received: Bool
    var timestamp: Date
}
