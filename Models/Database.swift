//
//  Database.swift
//  splitty
//
//  Created by Pranjal Satija on 9/2/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import CoreData

protocol Model {
    static var entityName: String { get }
    static func with(_ managedObject: NSManagedObject) -> Self?

    @discardableResult func insertManagedObject(into context: NSManagedObjectContext) -> NSManagedObject
}

struct Database {
    enum Error: Swift.Error {
        case notReady
    }

    static private var container: NSPersistentContainer?
    static private var isInitialized = false

    static func initialize(completion: @escaping (Swift.Error?) -> Void) {
        container = NSPersistentContainer(name: "splitty")
        container!.loadPersistentStores {(_, error) in
            completion(error)
            isInitialized = true
        }
    }
}

extension Database {
    static func commmit() throws {
        guard let context = container?.viewContext else {
            throw Error.notReady
        }

        try context.save()
    }

    static func insert(_ model: Model) throws {
        guard let context = container?.viewContext else {
            throw Error.notReady
        }

        model.insertManagedObject(into: context)
    }

    static func retrieve<T: Model>(_ model: T.Type) throws -> [T] {
        guard let context = container?.viewContext else {
            throw Error.notReady
        }

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: model.entityName)
        let managedObjects = try context.fetch(fetchRequest)
        return managedObjects.compactMap { model.with($0) }
    }
}
