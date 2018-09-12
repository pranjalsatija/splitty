//
//  AppDelegate.swift
//  splitty
//
//  Created by Pranjal Satija on 8/25/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func applicationDidFinishLaunching(_ application: UIApplication) {
        Database.initialize {(error) in
            if error != nil {
                let exitAction = UIAlertAction(title: "Exit", style: .default) {(_) in
                    exit(0)
                }

                self.window?.rootViewController?.showAlert(title: "Error", message: "We were unable to launch Splitty.",
                                                           actions: [exitAction])
            }

            self.computeTotals()
        }
    }

    func computeTotals() {
        let predicate = NSPredicate(format: "date != nil")
        guard let lists = try? Database.retrieve(List.self, predicate: predicate) else { return }

        for list in lists {
            var results = [Person: Double]()

            for item in list.itemsArray {
                for person in item.peopleArray {
                    results[person] = results[person, default: 0] + (item.price / Double(item.peopleArray.count))
                }
            }

            print("Totals for \(list.name ?? "Unnamed List"):\n\(results.map { ($0.key.name, CurrencyFormatter.string(from: NSNumber(value: $0.value))) }))")
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        try? Database.commmit()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        try? Database.commmit()
    }
}
