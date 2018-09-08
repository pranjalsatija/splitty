//
//  PastSplitsViewController.swift
//  splitty
//
//  Created by Pranjal Satija on 9/7/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import UIKit

class PastSplitsViewController: UIViewController {
    var lists = [List]()

    @IBOutlet weak private var splitsTableView: UITableView!
}

extension PastSplitsViewController {
    override func viewDidAppear(_ animated: Bool) {
        do {
            try loadData()
        } catch {
            showAlert(title: "Error", message: "We were unable to load your past lists.", actions: [.dismiss])
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

extension PastSplitsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TextTableViewCell.reuseIdentifier, for: indexPath)
        cell.textLabel?.text = lists[indexPath.row].name ?? "A List"
        cell.detailTextLabel?.text = lists[indexPath.row].description
        return cell
    }
}
