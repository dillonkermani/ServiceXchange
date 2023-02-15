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
                        .frame(width: 100, height: 100)
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
            }
        }
    }
}
