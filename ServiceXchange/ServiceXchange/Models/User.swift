//
//  User.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 1/30/23.
//

import Foundation

struct User: Encodable, Decodable {
    var uid: String
    var firstName: String
    var lastName: String
    var email: String

    var phone: String?
    var profileImageUrl: String?
    var listingIDs: [String]?
}
