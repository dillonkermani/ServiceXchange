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
            VStack{
                HStack(spacing: 12){
                    Text(CompanyName)
                        .font(.system(size: 30,
                                      weight: .regular,
                                      design: .default))
                        .padding(.trailing, 30)
                        //.frame(width: 50, height: 50)
                    //Spacer()
                    /*Text(NumberProvided)
                        .font(.system(size:20,
                                      weight: .regular,
                                      design: .default))
                    
                */}
            }
        }
    }
}
