//
//  AddItemManuallyViewController.swift
//  splitty
//
//  Created by Pranjal Satija on 8/25/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import UIKit

class AddItemManuallyViewController: UIViewController, NotificationObserver, StoryboardInstantiatable {
    var notificationObservers = [Any]()

    @IBOutlet weak private var itemNameTextField: UITextField!
    @IBOutlet weak private var peopleStackView: UIStackView!
    @IBOutlet weak private var priceTextField: UITextField!
    @IBOutlet weak private var scrollViewBottomConstraint: NSLayoutConstraint!
}

extension AddItemManuallyViewController {
    override func viewDidLoad() {
        configureKeyboardHandlers()
        configurePeopleStackView()
    }

    private func configureKeyboardHandlers() {
        let frameKey = UIResponder.keyboardFrameEndUserInfoKey
        let animationDurationKey = UIResponder.keyboardAnimationDurationUserInfoKey

        func keyboardChanged(_ notification: Notification) {
            guard let info = notification.userInfo, let keyboardFrameValue = info[frameKey] as? NSValue,
                  let animationDuration = info[animationDurationKey] as? NSNumber else {
                return
            }

            let keyboardHeight = keyboardFrameValue.cgRectValue.height
            let bottomSafeAreaInset = view.safeAreaInsets.bottom

            UIView.animate(withDuration: animationDuration.doubleValue) {
                self.scrollViewBottomConstraint.constant = keyboardHeight - bottomSafeAreaInset
                self.view.layoutIfNeeded()
            }
        }

        observeNotification(named: UIControl.keyboardWillChangeFrameNotification, using: keyboardChanged)
    }

    private func configurePeopleStackView() {
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

private extension AddItemManuallyViewController {
    @IBAction func itemNameTextFieldDidReturn() {
        priceTextField.becomeFirstResponder()
    }

    @IBAction func itemNameTextFieldDidEndEditing() {
        itemNameTextField.resignFirstResponder()
        itemNameTextField.layoutIfNeeded()
    }

    @IBAction func priceTextFieldChanged() {
        guard let text = priceTextField.text else {
            return
        }

        if text.isEmpty || text == CurrencyFormatter.currencySymbol {
            priceTextField.text = nil
        } else if !text.hasPrefix(CurrencyFormatter.currencySymbol) {
            priceTextField.text = CurrencyFormatter.currencySymbol + text
        }
    }

    @IBAction func priceTextFieldEndedEditing() {
        guard let text = priceTextField.text else {
            return
        }

        priceTextField.text = CurrencyFormatter.reformat(text)
        priceTextField.resignFirstResponder()
        priceTextField.layoutIfNeeded()
    }
}
