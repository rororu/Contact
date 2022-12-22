//
//  ViewController.swift
//  Contact
//
//  Created by Роман Романов on 24.10.2022.
//

import UIKit


class ViewController: UIViewController {
    
    //MARK: Свойства и View
    //-------------------------------------------------
    
    @IBOutlet var tableView: UITableView!
    @IBAction func showNewContactAlert() {
        let alertController = UIAlertController(title: "Add new contact", message: "Enter name and number", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Name"
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Numder"
        }
        
        let createButton = UIAlertAction(title: "Add", style: .default) { _ in
            guard let contactName = alertController.textFields?[0].text,
                  let comtactNumder = alertController.textFields?[1].text else {
                return
            }
            
            self.contacts.append(Contact(title: contactName, phone: comtactNumder))
            self.tableView.reloadData()
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertController.addAction(createButton)
        alertController.addAction(cancelButton)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: Переменные
    //-------------------------------------------------
    
    private var contacts = [ContactProtocol]() {
        didSet {
            contacts.sort{$0.title < $1.title}
            storage.save(contacts: contacts)
        }
    }
    
    var storage: ContactStorageProtocol!
    
    //MARK: Функции
    //-------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storage = ContactStorage()
        self.loadContacts()
    }
    
    private func loadContacts() {
        contacts = storage.load()
    }

}

extension ViewController: UITableViewDataSource {
    
    private func configureteCell(cell: inout UITableViewCell, for indexPath: IndexPath) {
        var configuration = cell.defaultContentConfiguration()
        configuration.text = contacts[indexPath.row].title
        configuration.secondaryText = contacts[indexPath.row].phone
        
        cell.contentConfiguration = configuration
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        
        if let reuseCell = tableView.dequeueReusableCell(withIdentifier: "MyCell") {
            print("Old cell \(indexPath.row)")
            cell = reuseCell
        } else {
            print("New cell \(indexPath.row)")
            cell = UITableViewCell(style: .default, reuseIdentifier: "MyCell")
        }
        
        configureteCell(cell: &cell, for: indexPath)
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionDelete = UIContextualAction(style: .destructive, title: "Delete") {_, _, _ in
            self.contacts.remove(at: indexPath.row)
            tableView.reloadData()
        }
        
        let actions = UISwipeActionsConfiguration(actions: [actionDelete])
        return actions
    }
    
}
 
