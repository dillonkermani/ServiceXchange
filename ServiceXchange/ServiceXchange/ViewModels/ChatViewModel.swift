//
//  ChatViewModel.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 2/28/23.
//

import Foundation
import Firebase

class ChatViewModel: ObservableObject {
        
    @Published var users: [User] = []
    @Published var chats: [Chat] = []

    func loadChatData(forUser: User) {
        
        for chatId in forUser.chats ?? [] {
            Ref.FIRESTORE_COLLECTION_CHATS.document(chatId).getDocument { (document, err) in
                if document != nil {
                    let dict = document!.data()
                    guard let decodedChat = try? Chat.init(fromDictionary: dict!) else { return }
                    self.chats.append(decodedChat)
                    
                    let recipientId = decodedChat.members.filter{ $0 == forUser.userId }
                    for userId in decodedChat.members {
                        if userId != forUser.userId {
                            Ref.FIRESTORE_COLLECTION_USERS.document(userId).getDocument { (document, err) in
                                if document != nil {
                                    let dict = document!.data()
                                    guard let decodedUser = try? User.init(fromDictionary: dict!) else { return }
                                    self.users.append(decodedUser)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
}
