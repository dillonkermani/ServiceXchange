//
//  ProfileCanvas.swift
//  ServiceXchange
//
//  Created by colton jeffrey on 3/8/23.
//

import SwiftUI

struct ProfileCanvas: View {
    
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        VStack{
            ZStack {
                
                VStack {
                    
                    Image("sunsetTest")
                        .resizable()
                    //.aspectRatio(contentMode: .fit)
                        .cornerRadius(20)
                        .padding(.horizontal, screenWidth / 40)
                        .padding(.bottom, screenHeight * 0.23)
                 
                    
                    
                }
                    
                VStack{
                    
                    Image("blankprofile")
                        .resizable()
                        .frame(width: screenWidth / 3.5, height: screenWidth / 3.5)
                        .clipShape(Circle())
                        .padding(.top, screenHeight / 11)
                    //.offset(y: UIScreen.main.bounds.height / 6)
                    
                    HStack {
                        Text("Company Name").font(.title2)
                            
                            .fontWeight(.bold)
                            .padding(.trailing, screenWidth * 0.2)
                            //.padding(.bottom, screenHeight * 0.05)
                        Image(systemName: "star")
                            .fontWeight(.bold)
                        Image(systemName: "star")
                            .fontWeight(.bold)
                        Image(systemName: "star")
                            .fontWeight(.bold)
                        Image(systemName: "star")
                            .fontWeight(.bold)
                        Image(systemName: "star")
                            .fontWeight(.bold)
                    }.padding(.bottom, screenHeight * 0.02)
                    
                    Text("\"been mosing lawns since 08. Using only unionized child labor. We will have your lawn be the talk of the town!\" ")
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, screenWidth * 0.05)
                    
                }
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 35,
                                  weight: .regular,
                                  design: .default))
                    .foregroundColor(.black)
                    .frame(width: 47, height: 47)
                    .background(.white)
                    .cornerRadius(30)
                    .padding(.bottom, screenHeight * 0.35)
                    .padding(.leading, screenWidth * 0.7)
                
                
                
                
            }
            
            
            ZStack {
                Rectangle()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.green)
                
                Text("user Postings go here")
            }
            
            //

//
            
            
            
            
            
            
        }
    }
}

struct ProfileCanvas_Previews: PreviewProvider {
    static var previews: some View {
        ProfileCanvas()
    }
}
