//
//  MessagesView.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 1/25/23.
//

import SwiftUI

struct MessagesView: View {
    
    @State var shouldShowLogOutOptions = false
    
    private var customNavBar: some View {
        HStack(spacing: 16) {
            
            Image(systemName: "person.fill")
                .font(.system(size: 34, weight: .heavy))
            
            VStack(alignment: .leading, spacing: 4) {
                Text("USERNAME")
                    .font(.system(size: 24, weight: .bold))
                
                HStack {
                    Circle()
                        .foregroundColor(.green)
                        .frame(width: 14, height: 14)
                    Text("online")
                        .font(.system(size: 12))
                        .foregroundColor(Color(.lightGray))
                }
                
            }
            
            Spacer()
            Button {
                shouldShowLogOutOptions.toggle()
            } label: {
                Image(systemName: "gear")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(.label))
            }
        }
        .padding()
        .actionSheet(isPresented: $shouldShowLogOutOptions) {
            .init(title: Text("Settings"), message: Text("What do you want to do?"), buttons: [
                .destructive(Text("Sign Out"), action: {
                    print("handle sign out")
                }),
                    .cancel()
            ])
        }
    }
    
    var body: some View {
        NavigationView {
            
            VStack {
                customNavBar
                messagesView
            }
            .overlay(
                newMessageButton, alignment: .bottom)
            .navigationBarHidden(true)
        }
    }
    
    private var messagesView: some View {
        ScrollView {
            ForEach(0..<10, id: \.self) { num in
                VStack {
                    HStack(spacing: 16) {
                        Image(systemName: "person.fill")
                            .font(.system(size: 32))
                            .padding(8)
                            .overlay(RoundedRectangle(cornerRadius: 44)
                                        .stroke(Color(.label), lineWidth: 1)
                            )
                        
                        
                        VStack(alignment: .leading) {
                            Text("Username")
                                .font(.system(size: 16, weight: .bold))
                            Text("Message sent to user")
                                .font(.system(size: 14))
                                .foregroundColor(Color(.lightGray))
                        }
                        Spacer()
                        
                        Text("2d")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    Divider()
                        .padding(.vertical, 8)
                }.padding(.horizontal)
                
            }.padding(.bottom, 50)
        }
    }
    
    private var newMessageButton: some View {
        Button {
            
        } label: {
            HStack {
                Spacer()
                Text("+ New Message")
                    .font(.system(size: 16, weight: .bold))
                Spacer()
            }
            .foregroundColor(.white)
            .padding(.vertical)
                .background(Color.green)
                .cornerRadius(32)
                .padding(.horizontal)
                .shadow(radius: 15)
        }
    }
}

//struct MessagesView: View {
//
//    var body: some View {
//        Text("MessagesView")
//        return ZStack{
//            VStack{
//                NavigationLink(destination: ServiceProfileView(), label: {
//                        CustomProfileButtonView(title: "Profile View", foregroundColor: .green, backgroundColor: .gray.opacity(0.5))
//                })
//            }
//        }
//    }
//}
//
//private func CustomProfileButtonView(title: String, foregroundColor: Color, backgroundColor: Color) -> some View {
//    return ZStack {
//        Rectangle()
//            .frame(width: UIScreen.main.bounds.width / 1.3, height: 50)
//            .shadow(radius: 5)
//            .foregroundColor(backgroundColor)
//        Text(title)
//            .font(.system(size: 17)).bold()
//            .foregroundColor(foregroundColor)
//    }.cornerRadius(30)
//}
//
//struct MessagesView_Previews: PreviewProvider {
//    static var previews: some View {
//        MessagesView()
//    }
//}
