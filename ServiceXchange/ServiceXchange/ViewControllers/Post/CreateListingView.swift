//
//  CreateListingView.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 1/25/23.
//

import SwiftUI

struct CreateListingView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            VStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Create Listing")
                        .foregroundColor(.blue)
                        .font(.system(size: 35))
                }

            
                
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.white)
    }
}

struct CreateListingView_Previews: PreviewProvider {
    static var previews: some View {
        CreateListingView()
    }
}
