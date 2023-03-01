//
//  CreateNewMessageView.swift
//  ServiceXchange
//
//  Created by 大橋諭貴 on 2/22/23.
//

import SwiftUI

struct chat_user: Identifiable {
    
    var id: String { uid }
    
    let uid, email, profileImageUrl: String
    
    init(data: [String: Any]) {
        self.uid = data["uid"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
    }
}

//class CreateNewMessageViewModel: ObservableObject {
//
////    @Published var users = [ChatUser]()
//    @Published var errorMessage = ""
//
//    init() {
//        fetchAllUsers()
//    }
//
//    private func fetchAllUsers() {
//        Ref.FIRESTORE_COLLECTION_USERS.getDocuments { (snapshot, error) in
//            guard let snap = snapshot else {
//                self.errorMessage = "Error Fetching data"
//                return
//            }
//
//            var users: [user] = []
//
//            for document in snap.documents {
//                let dict = document.data()
//                guard let decodedUsers = try? users.init(fromDictionary: dict) else { return }
//                users.append(decodedUsers)
//            }
//        }
//    }
//}
    
struct CreateNewMessageView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
//    @ObservedObject var vm = CreateNewMessageViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
//                Text(vm.errorMessage)
                
                ForEach(0..<10) { num in
                    Text("All Contactable Users")
                }
            }.navigationTitle("New Message")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Cancel")
                        }
                    }
                }
        }
    }
}

    
struct CreateNewMessageView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewMessageView()
    }
}
