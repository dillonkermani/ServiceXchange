//
//  User.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 1/30/23.
//

import Foundation

//object that goes to firebase and is loaded from firebase
// objects with default values or are optional are not required to be a listing
struct Listing: Encodable, Decodable {
    var listingId: String = ""
    var posterId: String
    var cardImageUrl: String = ""
    var title: String
    var description: String
    var datePosted: Double
    var categories: [String]?
}
