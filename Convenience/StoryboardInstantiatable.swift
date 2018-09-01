//
//  StoryboardInstantiatable.swift
//  splitty
//
//  Created by Pranjal Satija on 8/25/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import UIKit

protocol StoryboardInstantiatable {
    static var storyboardForInstantiation: UIStoryboard? { get }
    static var storyboardID: String { get }
}

extension StoryboardInstantiatable where Self: UIViewController {
    static var storyboardForInstantiation: UIStoryboard? {
        return nil
    }

    static var storyboardID: String {
        return String(describing: self)
    }
}

extension UIViewController {
    func instantiate<T: StoryboardInstantiatable>(_ type: T.Type) -> T? {
        let storyboard = type.storyboardForInstantiation ?? self.storyboard
        return storyboard?.instantiateViewController(withIdentifier: type.storyboardID) as? T
    }
}
