//
//  Database.swift
//  splitty
//
//  Created by Pranjal Satija on 9/2/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import CoreData

struct Database {
    enum Error: Swift.Error {
        case invalidObject
        case notReady
    }

    static var context: NSManagedObjectContext {
        return container?.viewContext ?? NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
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

    static func delete(_ object: NSManagedObject) throws {
        guard let context = container?.viewContext else {
            throw Error.notReady
        }

        context.delete(object)
    }

    static func insert(_ object: NSManagedObject) throws {
        guard let context = container?.viewContext else {
            throw Error.notReady
        }

        context.insert(object)
    }

    static func retrieve<T: NSManagedObject>(_ model: T.Type, predicate: NSPredicate? = nil,
                                             sortDescriptors: [NSSortDescriptor] = []) throws -> [T] {
        guard let context = container?.viewContext else {
            throw Error.notReady
        }

        guard let entityName = T.entity().name else {
            throw Error.invalidObject
        }

        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        return try context.fetch(fetchRequest)
    }
}
