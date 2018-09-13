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
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        try? Database.commmit()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        try? Database.commmit()
    }
}
