//
//  ImageCarouselView.swift
//  ServiceXchange
//
//  Created by Sam Wortzman on 2/11/23.
//

import SwiftUI
import Kingfisher

struct URLCarouselView: View {
    var urls: [String]
    
    func kf_image(url: String) -> some View {
        ZStack{
            KFImage(URL(string: url))
                .resizable()
                .brightness(-0.2)
                .blur(radius: 15)
                .opacity(1)

            KFImage(URL(string: url))
                .resizable()
                .scaledToFit()
        }
    }
    
    func image_slider() -> some View {
        SwiftUI.TabView(content: {
            ForEach(urls, id: \.self) { url in
                kf_image(url: url)
            }

        })
        .tabViewStyle(PageTabViewStyle())
    }
    
    var body: some View {
        if urls.count > 1 {
            NavigationView {
                image_slider()
            }
        }
        else if urls.count == 1 {
            kf_image(url: urls[0])
        }
        else {
            
        }
    }
}

struct URLCarouselView_Previews: PreviewProvider {
    static var previews: some View {
        URLCarouselView(urls:[
            "https://firebasestorage.googleapis.com:443/v0/b/servicexchange-5c2cb.appspot.com/o/1TOXMnwd2sCdpkeI77QN.jpg?alt=media&token=330f2014-13c3-4193-9e40-cd308e5af08d",
              "https://firebasestorage.googleapis.com:443/v0/b/servicexchange-5c2cb.appspot.com/o/Ai4n1oLYxObolvPBFl7u.jpg?alt=media&token=fce91b18-05f4-4d1a-865e-fd296605c37e"
        ])
//        URLCarouselView(urls: [], width: 300, height: 300)
    }
}
