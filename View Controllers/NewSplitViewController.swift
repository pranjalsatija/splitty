//
//  NewSplitViewController.swift
//  splitty
//
//  Created by Pranjal Satija on 8/25/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import UIKit

// MARK: Base Class
class NewSplitViewController: UIViewController, StoryboardInstantiatable {
    var list: List! {
        didSet {
            itemsTableView.reloadData()
            updateItemsTableViewFooter()
        }
    }

    @IBOutlet weak private var itemsTableView: UITableView!
    private var itemsTableViewFooter: TableViewFooterView!
}

// MARK: Setup
extension NewSplitViewController {
    override func viewDidAppear(_ animated: Bool) {
        list = .current ?? .empty
        updateItemsTableViewFooter()
    }

    override func viewDidLoad() {
        itemsTableView.register(TextTableViewCell.self, forCellReuseIdentifier: TextTableViewCell.reuseIdentifier)
    }

    private func updateItemsTableViewFooter() {
        let subtotal = list.itemsArray.reduce(0) { $0 + $1.price }
        let formattedSubtotal = CurrencyFormatter.string(from: NSNumber(value: subtotal))

        if list == nil || list.itemsArray.isEmpty {
            itemsTableView.tableFooterView = UIView()
        } else if itemsTableViewFooter == nil {
            itemsTableViewFooter = TableViewFooterView()
            itemsTableViewFooter.button.addTarget(self, action: #selector(saveSplitButtonPressed), for: .touchUpInside)
            itemsTableViewFooter.buttonText = "Save Split"
            itemsTableViewFooter.labelText = "Subtotal: \(formattedSubtotal)"
            itemsTableView.tableFooterView = itemsTableViewFooter
        } else if let itemsTableViewFooter = itemsTableViewFooter {
            itemsTableView.tableFooterView = itemsTableViewFooter
            itemsTableViewFooter.labelText = "Subtotal: \(formattedSubtotal)"
        }
    }
}

// MARK: User Interaction
private extension NewSplitViewController {
    @IBAction func addItemButtonPressed() {
        let actions: [UIAlertAction] = [
            UIAlertAction(title: "Using Barcode", style: .default, handler: addItemUsingBarcode),
            UIAlertAction(title: "Manually", style: .default, handler: addItemManually),
            .cancel
        ]

        showActionSheet(message: "Add item:", actions: actions)
    }

    func addItemManually(_ action: UIAlertAction) {
        let destination = instantiate(AddItemManuallyViewController.self)!
        destination.delegate = self
        navigationController?.pushViewController(destination, animated: true)
    }

    func addItemUsingBarcode(_ action: UIAlertAction) {

    }

    @objc func saveSplitButtonPressed() {
        let alert = UIAlertController(title: "Save Split", message: "Enter a name for this split.",
                                      preferredStyle: .alert)
        alert.addTextField {(textField) in
            textField.placeholder = "Name"
        }

        alert.addAction(UIAlertAction(title: "Add", style: .default) {(_) in
            guard let text = alert.textFields?.first?.text, !text.isEmpty else {
                return
            }

            self.saveSplit(name: text)
        })

        alert.addAction(.cancel)
        present(alert, animated: true)
    }

    private func saveSplit(name: String) {
        list.date = Date()
        list.name = name
        list = .empty
    }
}

// MARK: UITableViewDataSource and UITableViewDelegate
extension NewSplitViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TextTableViewCell.reuseIdentifier, for: indexPath)

        guard let list = list else {
            return cell
        }

        cell.textLabel?.text = list.itemsArray[indexPath.row].name
        cell.detailTextLabel?.text = list.itemsArray[indexPath.row].description
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        guard let list = list else {
            return
        }

        list.itemsArray.remove(at: indexPath.row)
        itemsTableView.deleteRows(at: [indexPath], with: .automatic)
        updateItemsTableViewFooter()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list?.itemsArray.count ?? 0
    }
}

// MARK: AddItemManuallyViewControllerDelegate
extension NewSplitViewController: AddItemManuallyViewControllerDelegate {
    func addItemManuallyViewController(_ addItemManuallyViewController: AddItemManuallyViewController,
                                       added item: Item) {
        addItemManuallyViewController.navigationController?.popToViewController(self, animated: true)
        list?.itemsArray.append(item)
        itemsTableView.reloadData()
        updateItemsTableViewFooter()
    }
}
