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
    var height = (UIScreen.main.bounds.width * 0.43)
}

struct CreateListingView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var session: SessionStore
    
    @ObservedObject var listingVM = ListingViewModel()
    
    @State var controls = CreateListingControls()
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    
                    underlinedTextField(title: "Service Name", text: $listingVM.title, width: 310, height: 40, color: CustomColor.sxcgreen)
                    underlinedTextField(title: "Details about service provided", text: $listingVM.description, width: 310, height: 40, color: CustomColor.sxcgreen)
                    
                    
                    
                    HStack() {
                        Button(action: {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            controls.pickedImageType = "card"
                            controls.showImagePicker = true
                        }) {
                            if controls.pickedImage == Image("user-placeholder") {
                                ZStack {
                                    Rectangle()
                                        .fill(CustomColor.sxcgreen)
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
                        .padding(35)
                        Spacer()
                    }
                    
                    postListingButton()
                    
                    
                }
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .sheet(isPresented: $controls.showImagePicker, content: {
                ImagePicker(showImagePicker: $controls.showImagePicker, pickedImage: $controls.pickedImage, imageData: $controls.pickedImageData, sourceType: .photoLibrary)
                    
            })
    }
    
    private func postListingButton() -> some View {
        return Button {
            listingVM.addListing(posterId: session.userSession!.userId, onSuccess: { listing in
                print("Succesfully posted Listing: \(listingVM.title)")
            }, onError: { errorMessage in
                print("Error posting Listing: \(listingVM.title)\nError: \(errorMessage)")
            })
        } label: {
            ZStack {
                Rectangle()
                    .frame(width: UIScreen.main.bounds.width / 1.2, height: 50)
                    .cornerRadius(15)
                    .foregroundColor(.blue)
                Text("Post Listing")
                    .foregroundColor(.white)
            }
        }

            

    }
}

struct CreateListingView_Previews: PreviewProvider {
    static var previews: some View {
        CreateListingView()
    }
}
