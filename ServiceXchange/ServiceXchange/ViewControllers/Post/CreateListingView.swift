//
//  CreateListingView.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 1/25/23.
//

import SwiftUI

struct CreateListingControls {
    var uploading = false
    var pickedImageType = ""
    var showImagePicker = false
    var pickedImage = Image("user-placeholder")
    var width = (UIScreen.main.bounds.width * 0.43)
    var height = (UIScreen.main.bounds.width * 0.43)
    var imageArray = UserDefaults.standard.data(forKey: "ImageArray")
    let gridItems = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    var showAlert = false
    var alertMessage = ""
    var postListingSuccess = false
    var showEditCategories = false
}

struct CreateListingView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var session: SessionStore
    
    @ObservedObject var listingVM = CreateListingViewModel()
    
    @State var controls = CreateListingControls()
    
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                VStack {
                    HStack {
                        Text("List Your Service")
                            .font(.system(size: 35)).bold()
                            .padding(25)
                        Spacer()
                    }
                    
                    MultiImageSelector()
                        .padding(.leading , 30)
                        .padding(.vertical, 25)
                    
                    underlinedTextField(title: "Service Name", text: $listingVM.title, width: 330, height: 40, color: listingVM.title.isEmpty ? .black : CustomColor.sxcgreen)
                    underlinedTextField(title: "Details about service provided", text: $listingVM.description, width: 330, height: 40, color: listingVM.description.isEmpty ? .black : CustomColor.sxcgreen)
                    
                    
                    pickCategoriesButton()
                    
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            if !listingVM.isPostable() {
                fillFieldsButton()
            } else {
                postListingButton()
            }
            
        }
        .sheet(isPresented: $controls.showImagePicker, content: {
            ImagePicker(showImagePicker: $controls.showImagePicker, pickedImage: $listingVM.pickedImage, imageData: $listingVM.pickedImageData, sourceType: .photoLibrary)
                
        })
        .sheet(isPresented: $controls.showEditCategories, content: {
            SelectCategoriesView(listingId: listingVM.listingId, categories: $listingVM.categories)
        })
        .onChange(of: listingVM.pickedImage) { _ in 
            listingVM.addListingImage()
        }
        .overlay {
            
            ActivityIndicator(isShowing: $controls.uploading)
                .frame(width: 50, height: 50)
                .foregroundColor(CustomColor.sxcgreen)
            
        }
        .alert(isPresented: $controls.showAlert) {

            Alert(title: Text(controls.alertMessage),
                message: Text(""),
                dismissButton: Alert.Button.default(
                    Text("OK"), action: {
                        if controls.postListingSuccess {
                            UserDefaults.standard.set(0, forKey: "selectedTabIndex")
                        }
                        
                    }
                )
            )
        }
    }
    
    private func pickCategoriesButton() -> some View {
        return HStack {
            Button(action: {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                controls.showEditCategories = true
            }) {
                HStack {
                    Spacer()
                    Text(listingVM.categories.count == 0 ? "No Categories Added" : "Edit Categories")
                        .font(.system(size: 17))
                        .padding(15)
                    
                    if listingVM.categories.count != 0 {
                        
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(listingVM.categories, id: \.self) { category in
                                    
                                    FilterTag(filterData: category)
                                }
                            }
                        }
                        
                        /*
                        LazyVGrid(columns: controls.gridItems, alignment: .center, spacing: 40) {
                         ForEach(listingVM.categories, id: \.self) { category in
                             
                             FilterTag(filterData: category)
                         }
                        }
                         */
                    }
                    Spacer()
                    
                }
                .background(.white)
                .foregroundColor(.black)
                .cornerRadius(17)
                .overlay(
                    RoundedRectangle(cornerRadius: 17)
                        .stroke(.black, lineWidth: 2)
                )
                .padding(15)
            }
        }.padding(30)
    }
    
    private func MultiImageSelector() -> some View {
        return ScrollView(.horizontal) {
            HStack {
                if !listingVM.maxImageCountReached() {
                    
                    Button {
                        controls.showImagePicker.toggle()
                    } label: {
                        ZStack {
                            Rectangle()
                                .fill(.white)
                                .frame(width: controls.width/1.5, height: controls.height/1.5)
                                .cornerRadius(17)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 17)
                                        .stroke(.black, lineWidth: 2)
                                )
                            Image(systemName: "plus")
                                .foregroundColor(.black)
                                .font(.system(size: 30))
                            
                        }.padding(1)
                    }
                    
                }
                
                ForEach(listingVM.images, id: \.id) { im in
                    ZStack {
                        im.image
                            .resizable()
                            .scaledToFill()
                            .frame(width: controls.width, height: controls.height)
                            .cornerRadius(17)
                            .overlay(
                                RoundedRectangle(cornerRadius: 17)
                                    .stroke(.black, lineWidth: 1)
                            )
                            .padding()
                        Button(action: {
                            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                            let index = listingVM.images.firstIndex(of: im) ?? -1 as Int
                            listingVM.images.remove(at: index)
                        }, label: {
                            Image(systemName: "minus.circle.fill")
                                .resizable()
                                .frame(width: 35, height: 35)
                                .foregroundColor(.red)
                                .background(Color.white)
                                .clipShape(Circle())
                                .overlay(
                                    RoundedRectangle(cornerRadius: 17.5)
                                        .stroke(.black, lineWidth: 1)
                                )
                        }).offset(x: controls.width / 2.1, y: -controls.height / 2.1)
                    }
                    
                    
                    
                }
                
                
            }
            
            
        }
    }
    
    // Button label for Post Listing Button if all required fields have not been filled yet.
    private func fillFieldsButton() -> some View {
        return Button {
            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
        } label: {
            HStack {
                Spacer()
                Text("Fill All Required Fields")
                    .font(.system(size: 17))
                    .padding(15)
                Spacer()
                
            }
            .background(.white)
            .foregroundColor(.black)
            .cornerRadius(17)
            .overlay(
                RoundedRectangle(cornerRadius: 17)
                    .stroke(.black, lineWidth: 2)
            )
            .padding(15)
        }
    }
    
    private func postListingButton() -> some View {
        return Button (action: {
            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
            controls.uploading = true
            Task {
                await listingVM.postListing(posterId: session.userSession!.userId,  onSuccess: { listing in // We pass in posterId so we can associate post with who posted it.
                    controls.alertMessage = "Success !"
                    controls.postListingSuccess.toggle()
                    controls.uploading = false

                }, onError: { errorMessage in
                    controls.alertMessage = "Error posting Listing: \(errorMessage)"
                    controls.uploading = false

                })
                controls.showAlert.toggle()

            }
        }, label: {
            HStack {
                Spacer()
                Text("Post Listing")
                    .font(.system(size: 17))
                    .bold()
                    .padding(15)
                Spacer()
                
            }
            .background(CustomColor.sxcgreen)
            .foregroundColor(.black)
            .cornerRadius(17)
            .overlay(
                RoundedRectangle(cornerRadius: 17)
                    .stroke(.black, lineWidth: 1)
            )
            .padding(15)
        }).disabled(controls.uploading)

            

    }
    
}

struct CreateListingView_Previews: PreviewProvider {
    static var previews: some View {
        CreateListingView()
    }
}
