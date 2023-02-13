//
//  UrlImage.swift
//  ServiceXchange
//
//  Created by Sam Wortzman on 2/13/23.
//

import SwiftUI
import Kingfisher

struct UrlImage: View {
    var url: String
    var body: some View {
        KFImage(URL(string: url))
            .placeholder({
                ShimmerPlaceHolder2()
            })
            .resizable()
            .scaledToFit()
    }
}

struct UrlImage_Previews: PreviewProvider {
    static var previews: some View {
        UrlImage(url: "https://upload.wikimedia.org/wikipedia/commons/c/ce/Pavle_Durisic.jpg")
    }
}
