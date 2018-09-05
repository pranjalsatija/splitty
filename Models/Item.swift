//
//  Item.swift
//  splitty
//
//  Created by Pranjal Satija on 8/25/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import CoreData

@objc class Item: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var people: Set<Person>
    @NSManaged var price: Double

    private var _peopleArray: [Person]!
    var peopleArray: [Person] {
        get {
            if _peopleArray == nil {
                _peopleArray = Array(people)
            }
            return _peopleArray
        }

        set {
            people = Set(newValue)
            _peopleArray = nil
        }
    }

    /// A displayable string that conveys the price of this item, along with the people it's for.
    override var description: String {
        return "\(formattedPrice) · \(formattedPeople)"
    }

    /// The names of the people this item is for, formatted for display.
    /// Examples: "Jeff", "Jeff and Bob", "Jeff, Bob, and John", etc.
    /// **Note**: This variable automatically orders the people involved alphabetically.
    var formattedPeople: String {
        let sortedPeopleArray = peopleArray.sorted { $0.name < $1.name }

        if sortedPeopleArray.isEmpty {
            return "Deleted People"
        } else if sortedPeopleArray.count == 1 {
            return sortedPeopleArray[0].name
        } else if sortedPeopleArray.count == 2 {
            return "\(sortedPeopleArray[0].name) and \(sortedPeopleArray[1].name)"
        } else {
            let firstPersonName = sortedPeopleArray.first!.name
            let lastPersonName = sortedPeopleArray.last!.name
            let middlePeople = sortedPeopleArray.dropFirst().dropLast()
            return firstPersonName + middlePeople.reduce("") { "\($0), \($1.name)" } + ", and \(lastPersonName)"
        }
    }

    /// The price of this item formatted for display.
    var formattedPrice: String {
        return CurrencyFormatter.string(from: NSNumber(value: price))
    }

    convenience init(name: String, people: Set<Person>, price: Double) {
        self.init(context: Database.context)
        self.name = name
        self.people = people
        self.price = price
    }
}
