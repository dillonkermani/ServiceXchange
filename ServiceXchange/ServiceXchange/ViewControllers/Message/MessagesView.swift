//
//  MessagesView.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 1/25/23.
//

import SwiftUI

struct MessagesView: View {

    var body: some View {
        Text("MessagesView")
        return ZStack{
            VStack{
                NavigationLink(destination: ServiceProfileView(), label: {
                        CustomProfileButtonView(title: "Profile View", foregroundColor: .green, backgroundColor: .gray.opacity(0.5))
                })
            }
        }
    }
}

private func CustomProfileButtonView(title: String, foregroundColor: Color, backgroundColor: Color) -> some View {
    return ZStack {
        Rectangle()
            .frame(width: UIScreen.main.bounds.width / 1.3, height: 50)
            .shadow(radius: 5)
            .foregroundColor(backgroundColor)
        Text(title)
            .font(.system(size: 17)).bold()
            .foregroundColor(foregroundColor)
    }.cornerRadius(30)
}

struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView()
    }
}
