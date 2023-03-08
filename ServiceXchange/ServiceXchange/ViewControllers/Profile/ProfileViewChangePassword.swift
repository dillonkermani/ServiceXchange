//
//  ProfileViewChangePassword.swift
//  ServiceXchange
//
//  Created by colton jeffrey on 3/7/23.
//

import SwiftUI

struct ProfileViewChangePassword: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack{
            Text("change Password View")
        }.navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 17)).bold()
                        }.foregroundColor(.black)
                    }
                }//ToolBarItem
            }//toolbar
    }
}

struct ProfileViewChangePassword_Previews: PreviewProvider {
    static var previews: some View {
        ProfileViewChangePassword()
    }
}
