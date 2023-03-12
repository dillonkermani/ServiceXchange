//
//  SavedListingsView.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 3/12/23.
//

import SwiftUI

struct SavedListingsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("Saved Listings")
        }.gesture(DragGesture()
            .onEnded { value in
                let direction = detectDirection(value: value)
                if direction == .left {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        )
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

struct SavedListingsView_Previews: PreviewProvider {
    static var previews: some View {
        SavedListingsView()
    }
}
