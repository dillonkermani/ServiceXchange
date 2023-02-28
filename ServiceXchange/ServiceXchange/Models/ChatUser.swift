//
//  ChatUser.swift
//  ServiceXchange
//
//  Created by 大橋諭貴 on 2/27/23.
//

import Foundation

struct ChatUser: Identifiable {
    
    var id: String { uid }
    
    let uid, firstName, email, profileImageUrl: String
    
    init(data: [String: Any]) {
        self.uid = data["userId"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.firstName = data["firstName"] as? String ?? ""
        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
    }
}
