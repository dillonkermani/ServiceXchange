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
            VStack(spacing: 0.0){
                //HStack(alignment: .top, spacing: 12.0){
                    Text(CompanyName)
                        .font(.system(size: 30,
                                      weight: .regular,
                                      design: .default))
                        .multilineTextAlignment(.leading)
                        .padding(.trailing, 30)
                    Text(NumberProvided)
                        .font(.system(size:20,
                                      weight: .regular,
                                      design: .default))
                        .multilineTextAlignment(.leading)
                        .padding(.trailing, 30.0)
                    
                     //}
            }
            
            
            
            
        }
    }
}

struct ServiceProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ServiceProfileView()
    }
}
