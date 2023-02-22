//
//  Constants.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 2/20/23.
//

import Foundation

class Constants {
    
    // Current pool of Categories. Might change to a Firestore collection in the future.
    static var categoryList = [CategoryCell(index: 0,title: "Handyman", imageName: "wrench.and.screwdriver"),
                               CategoryCell(index: 1,title: "Electrical", imageName: "bolt"),
                               CategoryCell(index: 2,title: "Painter", imageName: "paintbrush"),
                               CategoryCell(index: 3,title: "Carpenter", imageName: "house"),
                               CategoryCell(index: 4,title: "Plumber", imageName: "drop"),
                               CategoryCell(index: 5,title: "Mechanic", imageName: "car"),
                               CategoryCell(index: 6,title: "Pet Services", imageName: "pawprint"),
                               CategoryCell(index: 7,title: "Education", imageName: "brain.head.profile"),
                               CategoryCell(index: 8,title: "Health", imageName: "heart"),
                               CategoryCell(index: 9,title: "Travel", imageName: "airplane.departure"),
                               CategoryCell(index: 10,title: "Other", imageName: "ellipsis")
    ]
        
}
