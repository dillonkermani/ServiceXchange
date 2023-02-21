//
//  Constants.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 2/20/23.
//

import Foundation

class Constants {
    
    // Current pool of Categories. Might change to a Firestore collection in the future.
    static var categoryList = [CategoryCell(index: 0, title: "All", imageName: "suitcase.fill"),
                               CategoryCell(index: 1,title: "Food", imageName: "fork.knife"),
                               CategoryCell(index: 2,title: "Clothing", imageName: "tshirt"),
                               CategoryCell(index: 3,title: "Electronics", imageName: "laptopcomputer.and.iphone"),
                               CategoryCell(index: 4,title: "Education", imageName: "brain.head.profile"),
                               CategoryCell(index: 5,title: "Entertainment", imageName: "ticket"),
                               CategoryCell(index: 6,title: "Health", imageName: "heart"),
                               CategoryCell(index: 7,title: "Automotive", imageName: "car"),
                               CategoryCell(index: 8,title: "Home Decor", imageName: "house"),
                               CategoryCell(index: 9,title: "Pet Services", imageName: "comb"),
                               CategoryCell(index: 10,title: "Travel", imageName: "airplane.departure")]
}
