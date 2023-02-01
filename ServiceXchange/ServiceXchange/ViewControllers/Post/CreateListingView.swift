//
//  CreateListingView.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 1/25/23.
//

import SwiftUI

struct CreateListingControls {
    var pickedImageType = ""
    var showImagePicker = false
    var pickedImage = Image("user-placeholder")
    var pickedImageData = Data()
    var width = (UIScreen.main.bounds.width * 0.43)
    var height = (UIScreen.main.bounds.width * 0.43) * 1.4
}

struct CreateListingView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var listingVM = ListingViewModel()
    
    @State var controls = CreateListingControls()
    
    var body: some View {
        ZStack {
            VStack {
                
                VStack(alignment: .leading) {
                    Text("Service Image")
                        .bold()
                    Button(action: {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        controls.pickedImageType = "card"
                        controls.showImagePicker = true
                    }) {
                        if controls.pickedImage == Image("user-placeholder") {
                            ZStack {
                                Rectangle()
                                    .fill(Color.blue)
                                    .frame(width: controls.width, height: controls.height)
                                    .cornerRadius(5)
                                Text("Add Image")
                                    .foregroundColor(.white)
                            }
                        } else {
                            controls.pickedImage
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: controls.width, height: controls.height)
                                .cornerRadius(5)
                        }
                    }
                }
                
                underlinedTextField(title: "Title", text: $listingVM.title, width: 310, height: 40, color: .blue)
                underlinedTextField(title: "Description", text: $listingVM.description, width: 310, height: 40, color: .blue)
                
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Dismiss")
                        .foregroundColor(.blue)
                        .font(.system(size: 20))
                }

            
                
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(CustomColor.sxcgreen)
            .sheet(isPresented: $controls.showImagePicker, content: {
                ImagePicker(showImagePicker: $controls.showImagePicker, pickedImage: $controls.pickedImage, imageData: $controls.pickedImageData, sourceType: .photoLibrary)
                    
            })
    }
}

struct CreateListingView_Previews: PreviewProvider {
    static var previews: some View {
        CreateListingView()
    }
}
