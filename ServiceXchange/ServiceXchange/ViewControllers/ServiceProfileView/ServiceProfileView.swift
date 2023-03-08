//
//  ServiceProfileView.swift
//  ServiceXchange
//
//  Created by ServiceXchange on 2/8/23.
//

import Foundation
import SwiftUI
import FirebaseCore
import FirebaseFirestore

struct ServiceProfileView: View {
    var CompanyName = "Company Name"
    var NumberProvided = "100 Services Provided"
    var ProfileImage = ""
    var AboutText = "Placeholder Text"
    
    var body: some View {
        //@Environment(\.presentationMode) var presentationMode
        //@ObservedObject var UserVM = UserViewModel()
        NavigationView{
            return VStack{
                
                HStack(spacing: 12){
                    //Image
                    //stackView.addBackground(color: .gray)
                    Circle().fill(CustomColor.sxcgreen)
                        .frame(width: 150, height: 150)
                               Image("user-placeholder")
                    VStack {
                        Text(CompanyName)
                            .font(.system(size: 30,
                                          weight: .regular,
                                          design: .default))
                            .padding(.trailing, 30)
                        
                        Text(NumberProvided)
                         .font(.system(size:20,
                         weight: .regular,
                         design: .default))
                    }
                }.background(Color.gray)

                ScrollView{
                    Text(AboutText)
                     .font(.system(size:20,
                     weight: .regular,
                     design: .default))
                    
                }
                Spacer()
                /*NavigationLink(destination:
                                MessagesView(), label: {
                    CustomButtonView(title: "Message", foregroundColor:.black, backgroundColor: CustomColor.sxcgreen)
                })*/
            }
        }
    }
}

/*private func CustomButtonView(title: String, foregroundColor: Color, backgroundColor: Color) -> some View {
    return ZStack {
        Rectangle()
            .frame(width: UIScreen.main.bounds.width / 1.3, height: 50)
            .shadow(radius: 5)
            .foregroundColor(backgroundColor)
        Text(title)
            .font(.system(size: 17)).bold()
            .foregroundColor(foregroundColor)
    }.cornerRadius(40)
}*/
