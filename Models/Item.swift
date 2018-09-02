//
//  Item.swift
//  splitty
//
//  Created by Pranjal Satija on 8/25/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import Foundation

struct Item: Codable {
    var name: String
    var people: [Person]
    var price: Double

    var description: String {
        return "\(formattedPrice) · \(formattedPeople)"
    }

    var formattedPeople: String {
        if people.isEmpty {
            return ""
        } else if people.count == 1 {
            return people[0].name
        } else if people.count == 2 {
            return "\(people[0].name) and \(people[1].name)"
        } else {
            let firstPersonName = people.first!.name
            let lastPersonName = people.last!.name
            let middlePeople = people.dropFirst().dropLast()
            return firstPersonName + middlePeople.reduce("") { "\($0), \($1.name)" } + ", and \(lastPersonName)"
        }
    }

    var formattedPrice: String {
        return CurrencyFormatter.string(from: NSNumber(value: price))
    }
}
