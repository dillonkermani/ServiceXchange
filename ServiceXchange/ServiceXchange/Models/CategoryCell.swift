//
//  CategoryCell.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 2/19/23.
//

import Foundation

struct CategoryCell: Identifiable, Hashable {
    var id = UUID()
    var index: Int?
    var title: String
    var imageName: String
    var isSelected: Bool = false
    
}
