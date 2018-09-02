//
//  Logging.swift
//  splitty
//
//  Created by Pranjal Satija on 9/2/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import Foundation

struct Log {
    static var debugMarker = "ℹ️: "
    static var errorMarker = "⚠️: "

    static func debug(_ object: Any) {
        print("\(debugMarker)\(object)")
    }

    static func error(_ object: Any) {
        print("\(errorMarker)\(object)")
    }
}
