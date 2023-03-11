//
//  UrlImage.swift
//  ServiceXchange
//
//  Created by Sam Wortzman on 2/13/23.
//

import SwiftUI
import Kingfisher

func UrlImage(url: String) -> KFImage {
    return KFImage(URL(string: url))
        .placeholder({
            LoadingView()
        })
}

struct UrlImage_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            UrlImage(url: "https://upload.wikimedia.org/wikipedia/commons/c/ce/Pavle_Durisic.jpg")
                .cornerRadius(20)
                .padding(40)
            UrlImage(url: "")
                .cornerRadius(.infinity)
                .frame(width: 500, height: 500)
                .padding(20)
        }
    }
}
