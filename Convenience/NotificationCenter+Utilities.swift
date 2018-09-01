//
//  NotificationCenter+Utilities.swift
//  splitty
//
//  Created by Pranjal Satija on 8/29/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import Foundation

protocol NotificationObserver: class {
    var notificationObservers: [Any] { get set }
}

extension NotificationObserver {
    func observeNotification(named notificationName: Notification.Name, object: Any? = nil,
                             queue: OperationQueue = .main, using handler: @escaping (Notification) -> Void) {
        let observer = NotificationCenter.default.observe(notificationName, object: object, queue: queue,
                                                          using: handler)
        notificationObservers.append(observer)
    }

    func stopObserving() {
        notificationObservers.forEach(NotificationCenter.default.removeObserver)
        notificationObservers = []
    }
}

extension NotificationCenter {
    func observe(_ notificationName: Notification.Name, object: Any? = nil, queue: OperationQueue = .main,
                 using handler: @escaping (Notification) -> Void) -> NSObjectProtocol {
        return addObserver(forName: notificationName, object: object, queue: queue, using: handler)
    }
}
