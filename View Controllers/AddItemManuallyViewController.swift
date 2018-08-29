//
//  AddItemManuallyViewController.swift
//  splitty
//
//  Created by Pranjal Satija on 8/25/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import UIKit

class AddItemManuallyViewController: UIViewController, StoryboardInstantiatable {
    @IBOutlet weak private var peopleStackView: UIStackView!

    override func viewDidLoad() {
        // TODO: Load the names from the database.
        let subviews: [ToggleLabel] = ["Paul", "Ethan", "Pranjal", "Dylan"].map {(person) in
            let toggleLabel = ToggleLabel()
            toggleLabel.text = person
            toggleLabel.textColor = .black
            toggleLabel.tintColor = UIColor(white: 86 / 255, alpha: 1)
            return toggleLabel
        }

        for subview in subviews.dropLast() {
            peopleStackView.addArrangedSubview(subview)
            peopleStackView.addArrangedSubview(HorizontalSeparator())
        }

        if let last = subviews.last {
            peopleStackView.addArrangedSubview(last)
        }
    }
}

extension AddItemManuallyViewController {
    @IBAction private func priceTextFieldChanged(_ sender: UITextField) {
        guard let text = sender.text else {
            return
        }

        if text.isEmpty || text == CurrencyFormatter.currencySymbol {
            sender.text = nil
        } else if !text.hasPrefix(CurrencyFormatter.currencySymbol) {
            sender.text = CurrencyFormatter.currencySymbol + text
        }
    }

    @IBAction private func priceTextFieldEndedEditing(_ sender: UITextField) {
        guard let text = sender.text else {
            return
        }

        sender.text = CurrencyFormatter.reformat(text)
        sender.resignFirstResponder()
    }
}
