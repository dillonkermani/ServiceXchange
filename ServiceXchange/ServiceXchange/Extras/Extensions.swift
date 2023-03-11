//
//  Extensions.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 1/30/23.
//

import Foundation
import SwiftUI
import Kingfisher

extension Encodable {
    func toDictionary() throws -> [String: Any] {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = JSONEncoder.DateEncodingStrategy.secondsSince1970
        let data = try encoder.encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}

extension Decodable {
    init(fromDictionary: Any) throws {
        let data = try JSONSerialization.data(withJSONObject: fromDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = JSONDecoder.DateDecodingStrategy.secondsSince1970
        self = try decoder.decode(Self.self, from: data)
    }
}

extension KFImage {
    func basicKFModifiers(cgSize: CGSize) -> AnyView {
        return AnyView(
          self
            .setProcessor(DownsamplingImageProcessor(size: cgSize))
            .scaleFactor(UIScreen.main.scale)
            .cacheOriginalImage()
            .renderingMode(.original)
            .resizable()
        )
      }
}
