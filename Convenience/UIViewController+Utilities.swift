//
//  ActionSheetDisplayable.swift
//  splitty
//
//  Created by Pranjal Satija on 8/25/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import UIKit

extension UIAlertAction {
    static var cancel: UIAlertAction {
        return UIAlertAction(title: "Cancel", style: .cancel)
    }
}

extension UIViewController {
    func showActionSheet(title: String? = nil, message: String? = nil, actions: [UIAlertAction]) {
        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        actions.forEach(actionSheet.addAction)
        present(actionSheet, animated: true)
    }
}
