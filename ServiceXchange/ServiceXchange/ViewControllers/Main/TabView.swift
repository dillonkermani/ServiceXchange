//
//  TabView.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 1/25/23.
//

import SwiftUI

struct TabView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @AppStorage("selectedTabIndex") var selectedTabIndex: Int = 0
    @State var postPressed = false
    @State var promptLogin = false
    @State var plusTabPressed = false
    @EnvironmentObject var session: SessionStore
    
    
    @State private var userToPass : User = User(
        userId: "",
        firstName: "",
        lastName: "",
        email: "",
        isServiceProvider: false,
        listings: []
    )
    @State private var thisUser : Bool = true
    
    
    @EnvironmentObject var userVM : UserViewModel
    
    @StateObject var homeVM = HomeViewModel()
    var homeState = HomeViewControls()

    let icons = [
        "house",
        "map",
        "plus",
        "ellipsis.bubble",
        "person"
    ]
    
    let iconNames = [
        "Home",
        "Map",
        "Message",
        "Profile"
    ]
    
    var body: some View {
        VStack {
            ZStack {
                if !session.isLoggedIn {
                    NavigationView {
                        VStack {
                            HomeView(homeVM: homeVM, controls: homeState)
                        }.onAppear {
                            self.selectedTabIndex = 0
                        }
                    }
                } else {
                    switch selectedTabIndex {
                    case 0:
                        NavigationView {
                            VStack {
                                HomeView(homeVM: homeVM, controls: homeState)
                            }
                        }
                    case 1:
                        NavigationView {
                            VStack {
                                MapView()
                            }.navigationTitle("Map")
                        }
                    case 2:
                        NavigationView {
                            VStack {
                                CreateListingView()
                            }
                        }
                    case 3:
                        NavigationView {
                            VStack {
                                if session.isLoggedIn {
                                    ChatsView()
                                }
                            }
                        }
                    case 4:
                        
                        NavigationView {
                            
                            VStack {
                                if session.isLoggedIn {
    
                                    //ProfileViewMultiTest(user: $userToPass, thisUser : $thisUser)
                                    ProfileUserView()
                                }
                                
                            }.navigationTitle("Profile")

                        }
                    default:
                        NavigationView {
                            VStack {
                                
                            }
                        }.navigationTitle("Default")
                    }
                }
                
            }
            
            Spacer()
            
            Divider()
                .offset(y: 8)
    
            HStack {
                ForEach(0..<5, id: \.self) { i in
                    Spacer()
                    Button {
                        if session.isLoggedIn == false { // if NOT logged in
                            if i != 0 { // Don't promptLogin for HomeView
                                promptLogin.toggle()
                                
                            } else {
                                self.selectedTabIndex = i
                            }
                            
                        } else if session.isLoggedIn == true { // if logged in
                            self.selectedTabIndex = i
                            if i == 2 {
                                plusTabPressed = true
                            } else {
                                plusTabPressed = false
                            }
                        }
                        
                        
                        
                        UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                        // Present CreateListingView() as a full screen modal.
                    } label: {
                        if i == 2 {
                            Image(systemName: icons[i])
                                .font(.system(size: 20,
                                              weight: .regular,
                                              design: .default))
                                .foregroundColor(.black)
                                .frame(width: 64, height: 64)
                                .background(plusTabPressed ? CustomColor.sxcgreen : .white)
                                .cornerRadius(32)
                                .shadow(color: .gray, radius: plusTabPressed ? 5 : 0, x: 0, y: 0)
                                .overlay(
                                        RoundedRectangle(cornerRadius: 32)
                                            .stroke(.black, lineWidth: 2)
                                    )
                                .offset(y: -2)
                                .rotationEffect(.degrees(plusTabPressed ? 360 : 0))
                
                        } else {
                            Image(systemName: selectedTabIndex == i ? icons[i]+".fill" : icons[i])
                                .font(.system(size: 25,
                                              weight: .regular,
                                              design: .default))
                                .foregroundColor(selectedTabIndex == i ? CustomColor.sxcgreen : colorScheme == .dark ? .white : .black)
                        }
                        
                    }.fullScreenCover(isPresented: $promptLogin) {
                        LoginView()
                    }
                    Spacer()

                }
            }
        }.ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabView().environmentObject(SessionStore()).environmentObject(UserViewModel())
    }
}
