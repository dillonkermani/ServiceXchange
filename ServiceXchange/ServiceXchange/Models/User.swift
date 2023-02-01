//
//  User.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 1/30/23.
//

import Foundation

struct User: Encodable, Decodable {
    var userId: String
    var firstName: String
    var lastName: String
    var email: String
    var isServiceProvider: Bool
    var listingIDs: [String]

    var phone: String?
    var profileImageUrl: String?
}
