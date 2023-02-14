//
//  TabView.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 1/25/23.
//

import SwiftUI

struct TabView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State var selectedIndex = 0
    @State var postPressed = false
    @State var promptLogin = false
    @EnvironmentObject var session: SessionStore

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
                            HomeView()
                        }.onAppear {
                            self.selectedIndex = 0
                        }
                    }
                } else {
                    switch selectedIndex {
                    case 0:
                        NavigationView {
                            VStack {
                                HomeView()
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
                                    MessagesView()
                                }
                            }.navigationTitle("Messages")
                        }
                    case 4:
                        NavigationView {
                            VStack {
                                if session.isLoggedIn {
                                    ProfileView()
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
                                self.selectedIndex = i
                            }
                            
                        } else if session.isLoggedIn == true { // if logged in
                            self.selectedIndex = i
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
                                .background(CustomColor.sxcgreen)
                                .cornerRadius(32)
                                .shadow(color: .gray, radius: 5, x: 0, y: 0)
                                .overlay(
                                        RoundedRectangle(cornerRadius: 32)
                                            .stroke(.black, lineWidth: 2)
                                    )
                                .offset(y: -2)
                
                        } else {
                            Image(systemName: selectedIndex == i ? icons[i]+".fill" : icons[i])
                                .font(.system(size: 25,
                                              weight: .regular,
                                              design: .default))
                                .foregroundColor(selectedIndex == i ? CustomColor.sxcgreen : colorScheme == .dark ? .white : .black)
                        }
                        
                    }.fullScreenCover(isPresented: $promptLogin) {
                        LoginView()
                    }
                    Spacer()

                }
            }
        }
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabView()
    }
}
