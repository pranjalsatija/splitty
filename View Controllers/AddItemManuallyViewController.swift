//
//  AddItemManuallyViewController.swift
//  splitty
//
//  Created by Pranjal Satija on 8/25/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import UIKit

class AddItemManuallyViewController: UIViewController, StoryboardInstantiatable { }

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
