//
//  NewMessageView.swift
//  ServiceXchange
//
//  Created by 大橋諭貴 on 2/22/23.
//

import SwiftUI

private func fetchAllUsers()

struct NewMessageView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
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

struct NewMessageView_Previews: PreviewProvider {
    static var previews: some View {
//        NewMessageView()
        MessagesView()
    }
}
