//
//  Person.swift
//  splitty
//
//  Created by Pranjal Satija on 9/2/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import CoreData

struct Person: Codable, Equatable {
    static let entityName = "Person"

    let name: String
}

extension Person: Model {
    static func with(_ managedObject: NSManagedObject) -> Person? {
        if let name = managedObject.value(forKey: "name") as? String {
            return Person(name: name)
        } else {
            return nil
        }
    }

    func insertManagedObject(into context: NSManagedObjectContext) -> NSManagedObject {
        let entityDescription = NSEntityDescription.entity(forEntityName: "Person", in: context)
        let managedObject = NSManagedObject(entity: entityDescription ?? .init(), insertInto: context)
        managedObject.setValue(name, forKey: "name")
        return managedObject
    }
}
