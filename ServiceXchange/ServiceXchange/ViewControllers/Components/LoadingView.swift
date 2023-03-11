//
//  ShimmerPlaceHolder2.swift
//  ServiceXchange
//
//  Created by Sam Wortzman on 2/13/23.
//

import SwiftUI

struct LoadingView: View {
    @State var isLowOpacity = true
    let cycleTime = 3.0
    let minOpacity = 0.3
    let maxOpacity = 0.6
    let color = Color(hue: 308, saturation: 0.05, brightness: 0.3)
    var body: some View {
        Rectangle()
            .foregroundColor(.black)
            .opacity(isLowOpacity ? minOpacity : maxOpacity)
            .animation(
                Animation.easeIn(duration: self.cycleTime / 2)
                    .repeatForever(autoreverses: true),
                value: isLowOpacity)
            .onAppear {
                withAnimation(Animation.easeIn(duration: self.cycleTime / 2).repeatForever(autoreverses: true)) {
                        isLowOpacity.toggle()
                    }
                }
            
    }
}

struct LoadingViewParent<V: View>: View {
    var child: () -> V
    var body: some View {
        ZStack {
            LoadingView()
            child()
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            UrlImage(url: "")
                .frame(width: 400, height: 300)
            LoadingView()
                .cornerRadius(20)
                .padding()
            LoadingViewParent {
                LoadingView()
                    .cornerRadius(20)
                    .padding()
            }
                .cornerRadius(20)
                .padding()
        }
        
    }
}
