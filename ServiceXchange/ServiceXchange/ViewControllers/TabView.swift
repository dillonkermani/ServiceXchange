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
    
    let icons = [
        "house",
        "map",
        "plus",
        "ellipsis.bubble",
        "person"
    ]
    
    var body: some View {
        VStack {
            ZStack {
                switch selectedIndex {
                case 0:
                    NavigationView {
                        VStack {
                            HomeView()
                        }.navigationTitle("Home")
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
                            Text("")
                        }.navigationTitle("Post")
                    }
                case 3:
                    NavigationView {
                        VStack {
                            MessagesView()
                        }.navigationTitle("Messages")
                    }
                case 4:
                    NavigationView {
                        VStack {
                            ProfileView()
                        }.navigationTitle("Profile")
                    }
                default:
                    NavigationView {
                        VStack {
                            
                        }
                    }.navigationTitle("Default")
                }
            }
            
            Spacer()
            
            Divider()
            HStack {
                ForEach(0..<5, id: \.self) { i in
                    Spacer()
                    Button {
                        if i == 2 {
                            postPressed.toggle()
                        } else {
                            self.selectedIndex = i
                        }
                        UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                        // Present CreateListingView() as a full screen modal.
                    } label: {
                        if i == 2 {
                            Image(systemName: icons[i])
                                .font(.system(size: 25,
                                              weight: .regular,
                                              design: .default))
                                .foregroundColor(.white)
                                .frame(width: 70, height: 70)
                                .background(CustomColor.sxcgreen)
                                .cornerRadius(35)
                                .shadow(color: .black.opacity(0.3), radius: 3)
                        } else {
                            Image(systemName: selectedIndex == i ? icons[i]+".fill" : icons[i])
                                .font(.system(size: 25,
                                              weight: .regular,
                                              design: .default))
                                .foregroundColor(selectedIndex == i ? CustomColor.sxcgreen : colorScheme == .dark ? .white : .black)
                        }
                        
                    }.fullScreenCover(isPresented: $postPressed) {
                        CreateListingView()
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
