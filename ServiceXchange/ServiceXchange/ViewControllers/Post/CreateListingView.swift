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
    var showPreview = false
}

struct CreateListingView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var session: SessionStore
    
    @ObservedObject var listingVM = ListingViewModel()
    
    @State var controls = CreateListingControls()
    @State private var uploading = false
    
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                VStack {
                    HStack {
                        Text("List a Service")
                            .font(.system(size: 35)).bold()
                            .padding(25)
                        Spacer()
                    }
                    
                    MultiImageSelector()
                        .padding([.leading, .top, .bottom], 25)
                    
                    underlinedTextField(title: "Service Name", text: $listingVM.title, width: 310, height: 40, color: CustomColor.sxcgreen)
                    underlinedTextField(title: "Details about service provided", text: $listingVM.description, width: 310, height: 40, color: CustomColor.sxcgreen)
                    
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            VStack {
                if (listingVM.imageArray.isEmpty || listingVM.title.isEmpty || listingVM.description.isEmpty) {
                    fillFieldsButton()
                } else {
                    previewListingButton()
                    postListingButton()
                }
            }.offset(y: 8)
        }
        .sheet(isPresented: $controls.showImagePicker, content: {
            ImagePicker(showImagePicker: $controls.showImagePicker, pickedImage: $listingVM.image, imageData: $listingVM.imageData, sourceType: .photoLibrary)
                
        })
        .onChange(of: listingVM.image) { _ in //Should this be a function on listingVM?
            listingVM.images.append(listingVM.imageData)
            listingVM.imageArray.append(ListingImage(id: UUID(), image: listingVM.image))
        }
    }
    
    private func MultiImageSelector() -> some View {
        return ScrollView(.horizontal) {
            HStack {
                if listingVM.imageArray.count < 8 {
                    
                    Button {
                        controls.showImagePicker.toggle()
                    } label: {
                        ZStack {
                            Rectangle()
                                .fill(Color.gray.opacity(0.5))
                                .frame(width: controls.width/1.5, height: controls.height/1.5)
                                .cornerRadius(5)
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                        }
                    }
                    
                }
                
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
                
                
            }
            
            
        }
    }
    
    private func previewListingButton() -> some View {
        return Button {
            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
            controls.showPreview.toggle()
        } label: {
            HStack {
                Spacer()
                Text("Preview")
                    .bold()
                    .padding(10)
                Spacer()
            }
            .background(.blue)
            .foregroundColor(.white)
            .cornerRadius(5)
            .padding(.bottom, 10)
            .padding(.horizontal, 15)
        }

    }
    
    // Button label for Post Listing Button if all required fields have not been filled yet.
    private func fillFieldsButton() -> some View {
        return Button {
            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
        } label: {
            HStack {
                Spacer()
                Text("Fill in fields above")
                    .bold()
                    .padding(10)
                Spacer()
            }
            .background(Color.gray.opacity(0.5))
            .foregroundColor(.white)
            .cornerRadius(5)
            .padding(.bottom, 10)
            .padding(.horizontal, 15)
        }
    }
    
    private func postListingButton() -> some View {
        return Button (action: {
            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
            self.uploading = true
            Task {
                await listingVM.addListing(posterId: session.userSession!.userId, onSuccess: { listing in
                    print("Succesfully posted Listing: \(listingVM.title)")
                }, onError: { errorMessage in
                    print("Error posting Listing: \(listingVM.title)\nError: \(errorMessage)")
                })
                self.uploading = false
            }
        }, label: {
            HStack {
                Spacer()
                Text("Post Listing")
                    .bold()
                    .padding(10)
                Spacer()
            }
            .background(CustomColor.sxcgreen)
            .foregroundColor(.black)
            .cornerRadius(5)
            .padding(.bottom, 10)
            .padding(.horizontal, 15)
        }).disabled(self.uploading)

            

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
