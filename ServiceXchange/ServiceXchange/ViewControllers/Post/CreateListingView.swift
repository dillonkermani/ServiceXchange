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
    var width = (UIScreen.main.bounds.width * 0.43)
    var height = (UIScreen.main.bounds.width * 0.43)
    var imageArray = UserDefaults.standard.data(forKey: "ImageArray")
    let gridItems = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
}

struct CreateListingView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var session: SessionStore
    
    @ObservedObject var listingVM = ListingViewModel()
    
    @State var controls = CreateListingControls()
    
    var body: some View {
                VStack {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(listingVM.imageArray, id: \.id) { im in
                                ZStack {
                                    im.image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: controls.width, height: controls.height)
                                        .cornerRadius(5)
                                        .padding()
                                    Button(action: {
                                        UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                                        let index = listingVM.imageArray.firstIndex(of: im)! as Int
                                        listingVM.imageArray.remove(at: index)
                                    }, label: {
                                        Image(systemName: "minus.circle.fill")
                                            .resizable()
                                            .frame(width: 25, height: 25)
                                            .foregroundColor(.red)
                                            .background(Color.white)
                                            .clipShape(Circle())
                                    }).offset(x: controls.width / 2.1, y: -controls.height / 2.1)
                                }
                                
                                
                                
                            }
                            
                            if listingVM.imageArray.count < 8 {
                                
                                Button {
                                    controls.showImagePicker.toggle()
                                } label: {
                                    ZStack {
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.5))
                                            .frame(width: controls.width, height: controls.height)
                                            .cornerRadius(5)
                                        Image(systemName: "plus")
                                            .foregroundColor(.white)
                                    }
                                }
                                
                            }
                        }.padding(.leading, 15)
                            
                        
                    }
                    
                    underlinedTextField(title: "Service Name", text: $listingVM.title, width: 310, height: 40, color: CustomColor.sxcgreen)
                    underlinedTextField(title: "Details about service provided", text: $listingVM.description, width: 310, height: 40, color: CustomColor.sxcgreen)
                    
                    
                    postListingButton()
                    
                    
                
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .sheet(isPresented: $controls.showImagePicker, content: {
                ImagePicker(showImagePicker: $controls.showImagePicker, pickedImage: $listingVM.image, imageData: $listingVM.imageData, sourceType: .photoLibrary)
                    
            })
            .onChange(of: listingVM.image) { _ in
                listingVM.images.append(listingVM.imageData)
                listingVM.imageArray.append(ListingImage(id: UUID(), image: listingVM.image))
            }
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

struct ListingImage: Identifiable, Equatable {
    var id: UUID
    var image: Image
}
