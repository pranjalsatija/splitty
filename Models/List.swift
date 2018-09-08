//
//  List.swift
//  splitty
//
//  Created by Pranjal Satija on 9/2/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import CoreData

@objc class List: NSManagedObject {
    /// The current list, or the list the user is working on but hasn't explicitly saved.
    static var current: List? {
        let inProgressLists = try? Database.retrieve(List.self, predicate: NSPredicate(format: "date == nil"))
        try? inProgressLists?.dropFirst().forEach(Database.delete)
        return inProgressLists?.first
    }

    /// An empty list that can be used as a starting point. If there's no current list, this should be used.
    static var empty: List {
        return List(date: nil, name: nil, items: [])
    }

    static private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter
    }()

    @NSManaged var date: Date?

    override var description: String {
        let totalPrice = itemsArray.reduce(0) { $0 + $1.price }
        let formattedPrice = CurrencyFormatter.string(from: NSNumber(value: totalPrice))

        let date = self.date ?? Date()
        let formattedDate = List.dateFormatter.string(from: date)
        return "\(formattedDate) · \(formattedPrice)"
    }

    @NSManaged var name: String?
    @NSManaged private var items: NSMutableOrderedSet

    private var _itemsArray: [Item]!
    var itemsArray: [Item] {
        get {
            if _itemsArray == nil {
                _itemsArray = items.array as? [Item]
            }
            return _itemsArray
        }

        set {
            items = NSMutableOrderedSet(array: newValue)
            _itemsArray = nil
        }
    }

    convenience init(date: Date?, name: String?, items: NSMutableOrderedSet) {
        self.init(context: Database.context)
        self.date = date
        self.name = name
        self.items = items
    }
}
