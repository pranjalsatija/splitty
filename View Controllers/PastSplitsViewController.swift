//
//  PastSplitsViewController.swift
//  splitty
//
//  Created by Pranjal Satija on 9/7/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import UIKit

// MARK: Base Class
class PastSplitsViewController: UIViewController {
    var lists = [List]()

    @IBOutlet weak private var splitsTableView: UITableView!
}

// MARK: Setup
extension PastSplitsViewController {
    override func viewDidAppear(_ animated: Bool) {
        do {
            try loadData()
        } catch {
            showError(error)
            Log.error(error)
        }
    }

    override func viewDidLoad() {
        splitsTableView.register(TextTableViewCell.self, forCellReuseIdentifier: TextTableViewCell.reuseIdentifier)
        splitsTableView.tableFooterView = UIView()
    }

    private func loadData() throws {
        let sortDescriptor = NSSortDescriptor(keyPath: \List.date, ascending: false)
        lists = try Database.retrieve(List.self, predicate: NSPredicate(format: "date != nil"),
                                      sortDescriptors: [sortDescriptor])
        splitsTableView.reloadData()
    }
}

// MARK: UITableViewDataSource & UITableViewDelegate
extension PastSplitsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TextTableViewCell.reuseIdentifier, for: indexPath)
        cell.textLabel?.text = lists[indexPath.row].name ?? "A List"
        cell.detailTextLabel?.text = lists[indexPath.row].description()
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let list = lists[indexPath.row]
        let destination = instantiate(SplitDetailViewController.self)!
        destination.mode = .readOnly(list)
        navigationController?.pushViewController(destination, animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
}
