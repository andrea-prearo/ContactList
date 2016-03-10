//
//  ContactsTableViewController.swift
//  ContactList
//
//  Created by Prearo, Andrea on 3/6/16.
//  Copyright © 2016 Prearo, Andrea. All rights reserved.
//

import UIKit

let ContactCellId = "ContactCell"

class ContactsTableViewController: UITableViewController {

    var contacts: [Contact?]?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("Contacts", comment: "Contacts")
        contacts = nil

        Contact.getAll { [weak self] (success, contacts, error) -> () in
            if !success {
                dispatch_async(dispatch_get_main_queue()) {
                    let title = "Error"
                    if let error = error {
                        self?.showError(title, message: error.localizedDescription)
                    } else {
                        self?.showError(title, message: "Can't retrieve contacts.")
                    }
                }
            } else {
                self?.contacts = contacts
                self?.tableView.reloadData()
            }
        }
    }

    // MARK: UITableViewDataSource protocol methods
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let contacts = contacts {
            return contacts.count
        } else {
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ContactCellId, forIndexPath: indexPath) as! ContactCell
        guard let contacts = contacts,
            let contact = contacts[indexPath.row]
        else {
            return cell
        }

        cell.configure(ContactCellViewModel(contact: contact))
        return cell
    }

}
