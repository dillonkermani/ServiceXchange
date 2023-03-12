//
//  Rating.swift
//  ServiceXchange
//
//  Created by Sam Wortzman on 2/14/23.
//

import Foundation
import FirebaseCore
import FirebaseFirestore


//users/{userid}/ratings/{userid}
struct Rating: Encodable, Decodable {
    var stars: Int
    var msg: String?
}

func getRating(userId: String) async -> Double {
    let noRatings = 0.0
    do {
        var totalRating = 0
        let userRef = Ref.FIRESTORE_DOCUMENT_USERID(userId: userId)
        let ratings = try await userRef.collection("ratings").getDocuments()
        var ratingCount = ratings.count
        if ratingCount == 0 {
            return noRatings
        }
        for review in ratings.documents {
            let ratingInstance = try? Rating(fromDictionary: review.data())
            if ratingInstance == nil {
                ratingCount -= 1
            }
            totalRating += ratingInstance?.stars ?? 0
        }
        return Double(totalRating) / Double(ratingCount)
        
    }
    catch {
        return noRatings
    }
}

func rateUser(userIdToRate: String, raterId: String, rating: Int, msg: String? = nil) async -> Void {
    do {
        try await Ref.FIRESTORE_DOCUMENT_USERID(userId: userIdToRate)
                .collection("ratings")
                .document("\(raterId)").setData(
                    Rating(stars: rating, msg: msg).toDictionary()
                )
    }
    catch {
        print("error rating user")
        return
    }
}
