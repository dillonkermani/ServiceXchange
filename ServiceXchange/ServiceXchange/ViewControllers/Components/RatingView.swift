//
//  RatingView.swift
//  ServiceXchange
//
//  Created by Sam Wortzman on 2/16/23.
//

import SwiftUI

struct RatingView: View {
    var rating: Double
    private func roundRating(rating: Double) -> (ones: Int, tenths: Int) {
        let ones = Int(rating)
        let tenths = Int(rating * 10) % 10
        return (ones, tenths)
    }
    private func display_rating(rating: Double) -> some View {
        let (ones, tenths) = roundRating(rating: rating)
        return HStack(spacing: 0) {
            ForEach(1..<6) {i in
                if rating >= Double(i){
                    Image(systemName: "star.fill")
                        .foregroundColor(CustomColor.sxcgreen)
                }
                // if its x.2 and i + 1 < x ex: 3.3 i=3 yes 4.3 i=3 no
                else if tenths > 2 && rating + 1 > Double(i) {
                    Image(systemName: "star.leadinghalf.fill")
                        .foregroundColor(CustomColor.sxcgreen)
                }
                else {
                    Image(systemName: "star")
                        .foregroundColor(CustomColor.sxcgreen)
                    
                }
            }
            Text("(\(ones).\(tenths))")
  
        }
    }
    
    var body: some View {
        display_rating(rating: rating)
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            RatingView(rating: 4.3)
                .frame(width: 250, height: 20)
        }
    }
}
