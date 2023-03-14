//
//  ProfileUserView.swift
//  ServiceXchange
//
//  Created by colton jeffrey on 3/6/23.
//

import SwiftUI

struct ProfileUserViewControls {
    var pickerSelection = 0
    let gridItems = [GridItem(.flexible()), GridItem(.flexible())]
    var width = (UIScreen.main.bounds.width * 0.43)
    var height = (UIScreen.main.bounds.width * 0.43)
}

//if you are signed into the app and looking at your own profile
struct ProfileUserView: View {
    
    //pass in user information throught the user environment
    @EnvironmentObject var userVM: UserViewModel
    
    //pass in userSession through sessionStore (not sure if this will presist)
    @EnvironmentObject var session: SessionStore
    
    @StateObject var homeVM = HomeViewModel()
    
    @State var controls = ProfileUserViewControls()
    
    //to show the settings sheet
    @State private var showingSettingSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            
            ScrollView {
                
                VStack(spacing: 10) {
                    ProfileHeader()
                        .padding(.bottom, 50)
                    
                    Text(userVM.localCompanyName.isEmpty ? "No Company Name" : "\(userVM.localCompanyName)")
                        .font(.system(size: 30)).bold()
                        .multilineTextAlignment(.center)
                    
                    Text(userVM.localBio.isEmpty ? "No Company Description" : userVM.localBio)
                        .font(.system(size: 20))
                        .multilineTextAlignment(.center)
                    
                    Text(userVM.localPrimaryLocationServed.isEmpty ? "No Primary Location Specified" : "Location: \(userVM.localPrimaryLocationServed)")
                        .font(.system(size: 15))
                    
                    Rectangle()
                        .frame(height: 2)
                        .padding()
                    
                    VStack {
                        CustomSegmentedControl(preselectedIndex: $controls.pickerSelection, options: ["Listings", "Availability"])
                            
    
                        if controls.pickerSelection == 0 {
                            if controls.pickerSelection == 0 {
                                if homeVM.isLoading {
                                    LoadingView()
                                } else if homeVM.listings.isEmpty {
                                    Text("This user has no listings")
                                } else {
                                    ListingsGrid(listings: homeVM.listings)
                                        .onAppear {
                                            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                                        }
                                }
                            }
                        }
                        
                        if controls.pickerSelection == 1 {
                            CalendarEditView(forUser: userVM.localUserId)
                                .frame(minHeight: 300)
                                .padding()
                                .onAppear {
                                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                                }
                        }
                    }
                }
                
            }
        }.toolbar(.hidden)
            .onAppear{
                //initialize local variables if they have not been initialized
                //already
                if (userVM.initialized == false && session.userSession != nil){
                    userVM.updateLocalUserVariables(user: session.userSession!)
                }//if uninitailized
                homeVM.loadListings(forUser: userVM.user)
            }
    }
    
    private func TabPicker() -> some View {
        return VStack {
            Picker("", selection: $controls.pickerSelection) {
                Text("Listings").tag(0)
                Text("Availability").tag(1)
            }
            .pickerStyle(.segmented)
            .padding()
        }
    }
    
    
    
    private func ProfileHeader() -> some View {
        return ZStack {
            ProfileBackground(imageStr: userVM.localDescriptiveImageStr)
            
            ProfileImage(imageStr: userVM.localProfileImageUrl, diameter: 125)
                .offset(y: 80)
            
            NavigationLink(destination: ProfileSettingsView(), label: {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 30))
                    .foregroundColor(.black)
                    .frame(width: 45, height: 45)
                    .background(.white)
                    .cornerRadius(5)
                    .overlay(RoundedRectangle(cornerRadius: 5)
                        .stroke(Color(.label), lineWidth: 1)
                    )
                    .shadow(radius: 5)
            })
            .offset(x: Constants.screenWidth / 2.7, y: -45)
        }
    }
}


struct ProfileUserView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileUserView()
            .environmentObject(UserViewModel())
            .environmentObject(SessionStore())
    }
}
