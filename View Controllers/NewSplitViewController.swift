//
//  NewSplitViewController.swift
//  splitty
//
//  Created by Pranjal Satija on 8/25/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import UIKit

class NewSplitViewController: UIViewController, StoryboardInstantiatable {

}

extension NewSplitViewController {
    @IBAction private func addItemButtonPressed() {
        let actions: [UIAlertAction] = [
            UIAlertAction(title: "Using Barcode", style: .default, handler: addItemUsingBarcode),
            UIAlertAction(title: "Manually", style: .default, handler: addItemManually),
            .cancel
        ]

        showActionSheet(message: "Add item:", actions: actions)
    }
}

extension NewSplitViewController {
    private func addItemManually(_ action: UIAlertAction) {
        let destination = instantiate(AddItemManuallyViewController.self)!
        navigationController?.pushViewController(destination, animated: true)
    }

    private func addItemUsingBarcode(_ action: UIAlertAction) {

    }
}
