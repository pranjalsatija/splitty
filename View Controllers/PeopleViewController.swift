//
//  PeopleViewController.swift
//  splitty
//
//  Created by Pranjal Satija on 9/2/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import UIKit

// MARK: Base Class
class PeopleViewController: UIViewController {
    private var people = [Person]()

    @IBOutlet weak private var peopleTableView: UITableView!
}

// MARK: Setup
extension PeopleViewController {
    override func viewDidLoad() {
        peopleTableView.register(TextTableViewCell.self, forCellReuseIdentifier: TextTableViewCell.reuseIdentifier)
        peopleTableView.tableFooterView = UIView()

        do {
            try loadData()
        } catch {
            showAlert(title: "Error", message: "We were unable to load the list of people.", actions: [.dismiss])
        }
    }

    private func loadData() throws {
        let sortDescriptor = NSSortDescriptor(keyPath: \Person.name, ascending: true)
        people = try Database.retrieve(Person.self, sortDescriptors: [sortDescriptor])
        peopleTableView.reloadData()
    }

    private func delete(_ person: Person) {
        do {
            try Database.delete(person)
        } catch {
            showAlert(title: "Error", message: "We were unable to delete that person.", actions: [.dismiss])
        }
    }
}

// MARK: User Interaction
extension PeopleViewController {
    @IBAction func addPersonButtonPressed() {
        let alert = UIAlertController(title: "Add Person", message: "Enter the name of the person you want to add.",
                                      preferredStyle: .alert)
        alert.addTextField {(textField) in
            textField.placeholder = "Name"
        }

        alert.addAction(UIAlertAction(title: "Add", style: .default) {(_) in
            guard let text = alert.textFields?.first?.text, !text.isEmpty else {
                return
            }

            self.addPerson(named: text)
        })

        alert.addAction(.cancel)
        present(alert, animated: true)
    }

    private func addPerson(named name: String) {
        do {
            let predicateForName = NSPredicate(format: "name == %@", name)
            let existingPeopleWithName = try Database.retrieve(Person.self, predicate: predicateForName)
            if !existingPeopleWithName.isEmpty {
                showAlert(title: "Not Allowed", message: "A person with that name already exists.", actions: [.dismiss])
            } else {
                try Database.insert(Person(name: name))
                try loadData()
            }
        } catch {
            showAlert(title: "Error", message: "We were unable to add that person.", actions: [.dismiss])
            Log.error(error)
        }
    }
}

// MARK: UITableViewDataSource and UITableViewDelegate
extension PeopleViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TextTableViewCell.reuseIdentifier, for: indexPath)
        cell.textLabel?.text = people[indexPath.row].name
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        let person = people.remove(at: indexPath.row)
        delete(person)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
}
