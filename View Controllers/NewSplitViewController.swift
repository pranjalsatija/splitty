//
//  NewSplitViewController.swift
//  splitty
//
//  Created by Pranjal Satija on 8/25/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import UIKit

class NewSplitViewController: UIViewController, StoryboardInstantiatable {
    var list: List? {
        didSet {
            itemsTableView.reloadData()
        }
    }

    @IBOutlet weak private var itemsTableView: UITableView!
}

extension NewSplitViewController {
    override func viewDidLoad() {
        itemsTableView.register(TextTableViewCell.self, forCellReuseIdentifier: TextTableViewCell.reuseIdentifier)
        itemsTableView.tableFooterView = UIView()
    }

    override func viewDidAppear(_ animated: Bool) {
        list = .current ?? .empty
    }
}

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
}

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
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list?.items.count ?? 0
    }
}

extension NewSplitViewController: AddItemManuallyViewControllerDelegate {
    func addItemManuallyViewController(_ addItemManuallyViewController: AddItemManuallyViewController,
                                       added item: Item) {
        addItemManuallyViewController.navigationController?.popToViewController(self, animated: true)
        list?.itemsArray.append(item)
        itemsTableView.reloadData()
    }
}
