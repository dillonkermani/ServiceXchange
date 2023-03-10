//
//  User.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 1/30/23.
//

import Foundation

struct User: Encodable, Decodable, Hashable {
    var userId: String
    var firstName: String
    var lastName: String
    var email: String
    var isServiceProvider: Bool
    var listings: [String]?
    var phone: String?
    
    
    var profileImageUrl: String?
    var descriptiveImageStr: String?
    var companyName: String?
    var bio: String?
    var primaryLocationServed: String?
    
    // Firebase Cloud Messaging Device ID
    var fcmToken: String?
    
    var chats: [String]?
    
}
