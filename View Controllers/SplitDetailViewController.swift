//
//  SplitDetailViewController.swift
//  splitty
//
//  Created by Pranjal Satija on 8/25/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import UIKit

// MARK: Base Class
class SplitDetailViewController: UIViewController, StoryboardInstantiatable {
    static var storyboardForInstantiation: UIStoryboard? {
        return UIStoryboard(name: "NewSplit", bundle: .main)
    }

    var list: List! {
        get {
            switch mode {
            case .edit(let list), .readOnly(let list):
                return list
            }
        } set {
            if case .edit = mode {
                mode = .edit(newValue)
            } else {
                update()
            }
        }
    }

    var mode: Mode = .edit(nil) {
        didSet {
            update()
        }
    }

    @IBOutlet weak private var addButton: UIBarButtonItem!
    @IBOutlet weak private var itemsTableView: UITableView!
    private var itemsTableViewFooter: TableViewFooterView!
}

// MARK: Setup
extension SplitDetailViewController {
    override func viewDidAppear(_ animated: Bool) {
        if list == nil {
            list = .current ?? .empty
        }
    }

    override func viewDidLoad() {
        itemsTableView.register(TextTableViewCell.self, forCellReuseIdentifier: TextTableViewCell.reuseIdentifier)

        if Database.isInitialized {
            list = .current ?? .empty
        }
    }

    private func update() {
        guard isViewLoaded else {
            return
        }

        func updateItemsTableViewFooter() {
            if list == nil || list.itemsArray.isEmpty {
                itemsTableView.tableFooterView = UIView()
            } else if itemsTableViewFooter == nil {
                itemsTableViewFooter = TableViewFooterView()
                itemsTableViewFooter.button.addTarget(self, action: #selector(saveSplitButtonPressed),
                                                      for: .touchUpInside)
                itemsTableViewFooter.buttonText = "Save Split"
                itemsTableViewFooter.labelText = list.formattedTotals()
                itemsTableView.tableFooterView = itemsTableViewFooter
            } else if let itemsTableViewFooter = itemsTableViewFooter {
                itemsTableView.tableFooterView = itemsTableViewFooter
                itemsTableViewFooter.labelText = list.formattedTotals()
            }

            if case .readOnly = mode {
                itemsTableViewFooter.removeButton()
            }
        }

        func updateMode() {
            if case .readOnly = mode {
                navigationItem.setRightBarButtonItems(nil, animated: true)
                navigationItem.title = list.name ?? "View Split"
            } else if let addButton = addButton {
                navigationItem.setRightBarButtonItems([addButton], animated: true)
                navigationItem.title = "New Split"
            }
        }

        itemsTableView.reloadData()
        updateItemsTableViewFooter()
        updateMode()
    }
}

// MARK: User Interaction
private extension SplitDetailViewController {
    @IBAction func addItemButtonPressed() {
        let actions: [UIAlertAction] = [
            UIAlertAction(title: "Using Barcode", style: .default, handler: addItemUsingBarcode),
            UIAlertAction(title: "Manually", style: .default, handler: addItemManually),
            .cancel
        ]

        showActionSheet(message: "Add item:", actions: actions)
    }

    func addItemManually(_ action: UIAlertAction) {
        let destination = instantiate(ItemDetailViewController.self)!
        destination.delegate = self
        destination.mode = .newItem
        navigationController?.pushViewController(destination, animated: true)
    }

    func addItemUsingBarcode(_ action: UIAlertAction) {
        let destination = instantiate(ScanBarcodeViewController.self)!
        destination.delegate = self
        navigationController?.pushViewController(destination, animated: true)
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
extension SplitDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch mode {
        case .edit:
            return true
        case .readOnly:
            return false
        }
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
        list.itemsArray.remove(at: indexPath.row)
        itemsTableView.deleteRows(at: [indexPath], with: .automatic)
        update()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = list.itemsArray[indexPath.row]
        let destination = instantiate(ItemDetailViewController.self)!
        destination.delegate = self

        if case .readOnly = mode {
            destination.mode = .readOnly(item)
        } else {
            destination.mode = .editItem(item)
        }

        navigationController?.pushViewController(destination, animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list?.itemsArray.count ?? 0
    }
}

// MARK: ItemDetailViewControllerDelegate
extension SplitDetailViewController: ItemDetailViewControllerDelegate {
    func itemDetailViewController(_ itemDetailViewController: ItemDetailViewController, added item: Item) {
        navigationController?.popToViewController(self, animated: true)
        list.itemsArray.append(item)
        update()
    }

    func itemDetailViewController(_ itemDetailViewController: ItemDetailViewController, didEdit item: Item) {
        guard let index = list.itemsArray.index(of: item) else {
            return
        }

        navigationController?.popToViewController(self, animated: true)
        list.itemsArray[index] = item
        update()
    }
}

// MARK: ScanBarcodeViewControllerDelegate
extension SplitDetailViewController: ScanBarcodeViewControllerDelegate {
    func scanBarcodeViewControllerDidCancel(_ scanBarcodeViewController: ScanBarcodeViewController) {
        navigationController?.popToViewController(self, animated: true)
    }
}

// MARK: ScanBarcodeViewControllerDelegate
extension SplitDetailViewController {
    enum Mode {
        case edit(List!)
        case readOnly(List!)
    }
}
