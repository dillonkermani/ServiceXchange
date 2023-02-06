//
//  User.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 1/30/23.
//

import Foundation

struct Listing: Encodable, Decodable {
    var listingId: String = ""
    var posterId: String
    var cardImageUrl: String = ""
    var title: String
    var description: String
    var datePosted: Double
    var rate: Double?
}
