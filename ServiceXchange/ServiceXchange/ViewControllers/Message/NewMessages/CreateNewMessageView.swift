//
//  CreateNewMessageView.swift
//  ServiceXchange
//
//  Created by 大橋諭貴 on 2/22/23.
//

import SwiftUI
import Firebase

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

class CreateNewMessageViewModel: ObservableObject {
    
    @Published var users = [ChatUser]()
    @Published var errorMessage = ""
    
    init() {
        fetchAllUsers()
    }
    
    private func fetchAllUsers() {
        Firestore.firestore().collection("users")
            .getDocuments { documentsSnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to fetch users: \(error)"
                    print("Failed to fetch users: \(error)")
                    return
                }
                
                documentsSnapshot?.documents.forEach({ snapshot in
                    let data = snapshot.data()
                    let user = ChatUser(data: data)
                    if user.uid != Auth.auth().currentUser?.uid {
                        self.users.append(.init(data: data))
                    }
                })
                
                self.errorMessage = "Fetch Users Successfully"
            }
    }
}
    
struct CreateNewMessageView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var vm = CreateNewMessageViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
//                Text(vm.errorMessage)
                Divider()
                    .padding(.vertical, 4)
                ForEach(vm.users) { user in
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        HStack(spacing: 16) {
                            
                            if (user.profileImageUrl.isEmpty) {
                                Image(systemName: "person.fill")
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipped()
                                .cornerRadius(50)
                            } else {
                                UrlImage(url: user.profileImageUrl)
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipped()
                                    .cornerRadius(50)
                            }
                            Text(user.firstName)
                                .foregroundColor(Color(.label))
                            Spacer()
                        }.padding(.horizontal)
                    }
                    Divider()
                        .padding(.vertical, 4)
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
        MessagesView()
    }
}
