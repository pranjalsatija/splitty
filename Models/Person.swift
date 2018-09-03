//
//  Person.swift
//  splitty
//
//  Created by Pranjal Satija on 9/2/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import CoreData

@objc class Person: NSManagedObject {
    @NSManaged var name: String

    convenience init(name: String) {
        self.init(context: Database.context)
        self.name = name
    }
}
