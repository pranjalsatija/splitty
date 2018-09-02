//
//  List.swift
//  splitty
//
//  Created by Pranjal Satija on 9/2/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import Foundation

struct List: Codable {
    static var current: List? {
        get {
            if let data = UserDefaults.standard.data(forKey: "current_list") {
                return try? List.decoded(from: data)
            } else {
                return nil
            }
        }

        set {
            do {
                try UserDefaults.standard.set(newValue.jsonEncoded(), forKey: "current_list")
            } catch {
                Log.error(error)
            }
        }
    }

    static let empty = List(date: nil, name: nil, items: [])

    var date: Date?
    var name: String?
    var items: [Item]
}
