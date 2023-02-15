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
    
    var body: some View {
        NavigationView{
            return ZStack{
                VStack{
                    HStack(spacing: 12){
                        Text(CompanyName)
                            .font(.system(size: 30,
                                          weight: .regular,
                                          design: .default))
                            .padding(.trailing, 30)
                        /*Text(NumberProvided)
                         .font(.system(size:20,
                         weight: .regular,
                         design: .default))
                         
                         */}
                }
            }
        }
    }
}
