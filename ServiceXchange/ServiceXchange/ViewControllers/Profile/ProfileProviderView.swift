//
//  ProfileProviderView.swift
//  ServiceXchange
//
//  Created by colton jeffrey on 3/7/23.
//

import SwiftUI

struct ProfileProviderViewControls {
    var pickerSelection = 0
    let gridItems = [GridItem(.flexible()), GridItem(.flexible())]
    var width = (UIScreen.main.bounds.width * 0.43)
    var height = (UIScreen.main.bounds.width * 0.43)
    var showRatingSheet: Bool = false
    var promptLogin = false
}

struct RateProfile: View {
    let forUser: String
    let byUser: String?
    @State var showAlert = false
    @State var currentUserRating: Int = 0
    var body: some View{
        VStack{
            Text("How did I do?")
                .font(.system(.title)).bold()
            HStack {
                ForEach(1..<6) { i in
                    Button( action: {
                        Task {
                            guard let currentUser = byUser else {
                                showAlert = true
                                return
                            }
                            currentUserRating = i
                            await rateUser(userIdToRate: forUser, raterId: currentUser, rating: i)
                        }
                    }, label: {
                        if i > currentUserRating {
                            Image(systemName: "star")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(CustomColor.sxcgreen)

                        }
                        else {
                            Image(systemName: "star.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(CustomColor.sxcgreen)
                        }
                    })
                    
                }
            } //hstack
            .padding(.horizontal, 70)
            .padding(.vertical, 10)
            .alert(isPresented: $showAlert, content: {
                Alert(title: Text("You must be logged in to rate this account"))
            })
        }
    }
}

struct ProfileProviderView: View {
    
    var user: User
    let rating: Double
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var session: SessionStore
    
    @StateObject var homeVM = HomeViewModel()
    
    @State var controls = ProfileProviderViewControls()

    
    var body: some View {

        let arrowSize: CGFloat = 17
        
        ZStack {
            ScrollView {
                
                VStack(spacing: 10) {
                    ProfileHeader()
                        .padding(.bottom, 50)
                    
                    Text(user.companyName?.isEmpty ?? true ? "No Company Name" : "\(user.companyName!)")
                        .font(.system(size: 30)).bold()
                    RatingView(rating: rating)
                    Button( action: {
                        if session.isLoggedIn {
                            controls.showRatingSheet = true
                        } else {
                            controls.promptLogin = true
                        }
                    },label:{
                        Text("Rate").underline()
                    }).popover(isPresented: $controls.showRatingSheet, content: {
                        RateProfile(forUser: user.userId, byUser: session.userSession?.userId)
                    })
                    .presentationDetents([.fraction(0.2)])
                    .fullScreenCover(isPresented: $controls.promptLogin) {
                        LoginView()
                    }
                    Text(user.bio?.isEmpty ?? true ? "No Company Description" : user.bio!)
                        .font(.system(size: 20)).multilineTextAlignment(.center)
                    
                    Text(user.primaryLocationServed?.isEmpty ?? true ? "No Primary Location Specified" : "Location: \(user.primaryLocationServed!)")
                        .font(.system(size: 17))
                    
                    Rectangle()
                        .frame(height: 2)
                        .padding()

                    if session.userSession != nil {
                        if user.userId != session.userSession!.userId {
                            RequestServiceButton(fromUser: session.userSession!, toUser: user)
                        }
                    }
                    
                    VStack {
                        
                        CustomSegmentedControl(preselectedIndex: $controls.pickerSelection, options: ["Listings", "Availability"])

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
                        
                        if controls.pickerSelection == 1 {
                            CalendarView(forUser: user.userId)
                                .frame(minHeight: 300)
                                .padding()
                                .onAppear {
                                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                                }
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "arrow.left")
                                .font(.system(size: arrowSize)).bold()
                        }.foregroundColor(.black)
                    }
                }//ToolBarItem
                
                
            }//toolbar
            .gesture(DragGesture()
                .onEnded { value in
                    let direction = detectDirection(value: value)
                    if direction == .left {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            )
            .onAppear {
                homeVM.loadListings(forUser: user)
            }
    }
    
    private func ProfileHeader() -> some View {
        return ZStack {
            ProfileBackground(imageStr: user.descriptiveImageStr ?? "")
            
            ProfileImage(imageStr: user.profileImageUrl ?? "", diameter: 125)
                .offset(y: 80)
            
        }
    }
}

struct ProfileProvider_Previews: PreviewProvider {
    static var previews: some View {
        ProfileProviderView(user: User(userId: "7syxwXFCwYh6HevOXCD9oTJJV7n1", firstName: "Sam", lastName: "W", email: "fake@email.com", isServiceProvider: true), rating: 3.6)
            .environmentObject(SessionStore())
    }
}
