//
//  ItemDetailViewController.swift
//  splitty
//
//  Created by Pranjal Satija on 8/25/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import UIKit

protocol ItemDetailViewControllerDelegate: class {
    func itemDetailViewController(_ itemDetailViewController: ItemDetailViewController, added item: Item)
    func itemDetailViewController(_ itemDetailViewController: ItemDetailViewController, didEdit item: Item)
}

// MARK: Base Class
class ItemDetailViewController: UIViewController, NotificationObserver, StoryboardInstantiatable {
    weak var delegate: ItemDetailViewControllerDelegate?
    var mode: Mode = .newItem {
        didSet { configureForMode() }
    }

    var notificationObservers = [Any]()

    private var isFormValid = false {
        didSet {
            doneButton.isEnabled = isFormValid
        }
    }

    private var toggleLabelToPersonDictionary = [ToggleLabel: Person]()

    @IBOutlet weak private var doneButton: UIBarButtonItem!
    @IBOutlet weak private var itemNameTextField: UITextField!
    @IBOutlet weak private var peopleStackView: UIStackView!
    @IBOutlet weak private var priceTextField: UITextField!
    @IBOutlet weak private var scrollViewBottomConstraint: NSLayoutConstraint!
    private var peopleToggleLabels: [ToggleLabel]!
}

// MARK: Setup
extension ItemDetailViewController {
    override func viewDidLoad() {
        isFormValid = false
        configureKeyboardHandlers()
        configurePeopleStackView()
        configureForMode()
    }

    private func configureForMode() {
        guard isViewLoaded else {
            return
        }

        func configure(with item: Item) {
            itemNameTextField.text = item.name
            priceTextField.text = CurrencyFormatter.string(from: NSNumber(value: item.price))
            peopleToggleLabels.forEach {(toggleLabel) in
                guard let person = person(for: toggleLabel) else {
                    return
                }

                toggleLabel.isOn = item.people.contains(person)
            }
        }

        func setUserInteractionEnabled(_ isEnabled: Bool) {
            [itemNameTextField, priceTextField].forEach { $0?.isUserInteractionEnabled = isEnabled }
            peopleToggleLabels.forEach { $0.isUserInteractionEnabled = isEnabled }
            navigationItem.setRightBarButtonItems(isEnabled ? [doneButton] : nil, animated: true)
        }

        switch mode {
        case .editItem(let item):
            setUserInteractionEnabled(true)
            configure(with: item)
        case .newItem:
            setUserInteractionEnabled(true)
        case .readOnly(let item):
            setUserInteractionEnabled(false)
            configure(with: item)
        }
    }

    private func set(_ person: Person, for toggleLabel: ToggleLabel) {
        toggleLabelToPersonDictionary[toggleLabel] = person
    }

    private func person(for toggleLabel: ToggleLabel) -> Person? {
        return toggleLabelToPersonDictionary[toggleLabel]
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
        let sortDescriptor = NSSortDescriptor(keyPath: \Person.name, ascending: true)
        peopleToggleLabels = try? Database.retrieve(Person.self, sortDescriptors: [sortDescriptor]).map {(person) in
            let toggleLabel = ToggleLabel()
            toggleLabel.text = person.name
            toggleLabel.textColor = .black
            toggleLabel.tintColor = UIColor(white: 86 / 255, alpha: 1)
            toggleLabel.addTarget(self, action: #selector(formDidUpdate), for: .valueChanged)
            set(person, for: toggleLabel)
            return toggleLabel
        }

        for personToggleLabel in peopleToggleLabels.dropLast() {
            peopleStackView.addArrangedSubview(personToggleLabel)
            peopleStackView.addArrangedSubview(HorizontalSeparator())
        }

        if let last = peopleToggleLabels.last {
            peopleStackView.addArrangedSubview(last)
        }
    }
}

// MARK: User Interaction
private extension ItemDetailViewController {
    @IBAction func doneButtonPressed() {
        guard let itemName = itemNameTextField.text, let priceString = priceTextField.text,
              let price = CurrencyFormatter.number(from: priceString) else {
            return
        }

        let people = peopleToggleLabels.filter { $0.isOn }.compactMap(person)

        if case .newItem = mode {
            let item = Item(name: itemName, people: Set(people), price: price.doubleValue)
            delegate?.itemDetailViewController(self, added: item)
        } else if case let .editItem(item) = mode {
            item.name = itemName
            item.peopleArray = people
            item.price = price.doubleValue
            delegate?.itemDetailViewController(self, didEdit: item)
        }
    }

    @objc func formDidUpdate() {
        guard let itemName = itemNameTextField.text, let price = priceTextField.text else {
            isFormValid = false
            return
        }

        isFormValid = !itemName.isEmpty && !price.isEmpty && peopleToggleLabels.contains { $0.isOn }
    }

    @IBAction func itemNameTextFieldChanged() {
        formDidUpdate()
    }

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

        formDidUpdate()
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

// Mode
extension ItemDetailViewController {
    enum Mode {
        case editItem(Item)
        case newItem
        case readOnly(Item)
    }
}
