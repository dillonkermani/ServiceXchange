//
//  Constants.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 2/20/23.
//

import Foundation

class Constants {
    
    // Current pool of Categories. Might change to a Firestore collection in the future.
    static var categoryList = [CategoryCell(index: 0, title: "All", imageName: "safari", isSelected: true),
                               CategoryCell(index: 1,title: "Handyman", imageName: "wrench.and.screwdriver"),
                               CategoryCell(index: 2,title: "Electrical", imageName: "bolt"),
                               CategoryCell(index: 3,title: "Painter", imageName: "paintbrush"),
                               CategoryCell(index: 4,title: "Carpenter", imageName: "house"),
                               CategoryCell(index: 5,title: "Plumber", imageName: "drop"),
                               CategoryCell(index: 6,title: "Mechanic", imageName: "car"),
                               CategoryCell(index: 7,title: "Pet Services", imageName: "pawprint"),
                               CategoryCell(index: 8,title: "Education", imageName: "brain.head.profile"),
                               CategoryCell(index: 9,title: "Health", imageName: "heart"),
                               CategoryCell(index: 10,title: "Travel", imageName: "airplane.departure")]
}
