//
//  List.swift
//  splitty
//
//  Created by Pranjal Satija on 9/2/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import CoreData

@objc class List: NSManagedObject {
    static var current: List? {
        let inProgressLists = try? Database.retrieve(List.self, predicate: NSPredicate(format: "date == nil"))
        try? inProgressLists?.dropFirst().forEach(Database.delete)
        return inProgressLists?.first
    }

    static var empty: List {
        return List(date: nil, name: nil, items: [])
    }

    @NSManaged var date: Date?
    @NSManaged var name: String?
    @NSManaged var items: Set<Item>

    private var _itemsArray: [Item]!
    var itemsArray: [Item] {
        get {
            if _itemsArray == nil {
                _itemsArray = Array(items)
            }
            return _itemsArray
        }

        set {
            items = Set(newValue)
            _itemsArray = nil
        }
    }

    convenience init(date: Date?, name: String?, items: Set<Item>) {
        self.init(context: Database.context)
        self.date = date
        self.name = name
        self.items = items
    }
}
