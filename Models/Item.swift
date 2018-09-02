//
//  Item.swift
//  splitty
//
//  Created by Pranjal Satija on 8/25/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import Foundation

struct Item: Codable {
    // var consumers: [People]
    var name: String
    var price: Double

    var formattedPrice: String {
        return CurrencyFormatter.string(from: NSNumber(value: price))
    }
}
