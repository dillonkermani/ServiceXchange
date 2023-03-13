//
//  ChangePasswordview.swift
//  ServiceXchange
//
//  Created by colton jeffrey on 3/7/23.
//

import SwiftUI

struct ChangePasswordView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack{
            Text("Change Password")
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 17)).bold()
                        }.foregroundColor(.black)
                    }
                    
                }
            }
        }
        .onAppear {
            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
        }
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView()
    }
}
