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

    private var contacts: [Contact?]?
    private var selectedIndexPath: NSIndexPath? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpStyle()

        Contact.getAll { [weak self] (success, contacts, error) -> () in
            if !success {
                dispatch_async(dispatch_get_main_queue()) {
                    let title = "Error"
                    if let error = error {
                        self?.showError(title, message: error.localizedDescription)
                    } else {
                        self?.showError(title, message: NSLocalizedString("Can't retrieve contacts.", comment: "Can't retrieve contacts."))
                    }
                }
            } else {
                self?.contacts = contacts
                self?.tableView.reloadData()
            }
        }
    }

    // MARK: Private Methods
    
    func setUpStyle() {
        tableView.backgroundColor = UIColor.defaultBackgroundColor()
    }

    func showDeleteContactAlert(contact: Contact) {
        let formatString = NSLocalizedString("Are you sure you want to delete %@?", comment: "Are you sure you want to delete this contact?")
        let contactName: String
        if let _ = contact.firstName,
            _ = contact.lastName {
            contactName = contact.fullName
        } else {
            contactName = NSLocalizedString("this contact", comment: "this contact")
        }
        let message = String(format: formatString, contactName)
        let alert = UIAlertController(title: NSLocalizedString("Delete Contact", comment: "Delete Contact"),
            message: message,
            preferredStyle: .Alert)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: handleDeleteContact)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: cancelDeleteContact)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func handleDeleteContact(alertAction: UIAlertAction!) -> Void {
        if let indexPath = selectedIndexPath,
            contacts = contacts {
            tableView.beginUpdates()

            self.contacts = contacts.dropAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            selectedIndexPath = nil
            
            tableView.endUpdates()
        }
    }
    
    func cancelDeleteContact(alertAction: UIAlertAction!) {
        selectedIndexPath = nil
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
            contact = contacts[indexPath.row]
        else {
            return cell
        }

        cell.configure(ContactCellViewModel(contact: contact))
        return cell
    }

    // MARK: UITableViewDelegate protocol methods
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedIndexPath = indexPath
        performSegueWithIdentifier(SegueIdentifiers.ContactsToContactDetailSegue.rawValue, sender: self)
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            selectedIndexPath = indexPath
            guard let contacts = contacts,
                contact = contacts[indexPath.row]
            else {
                return
            }
            showDeleteContactAlert(contact)
        }
    }

    // MARK: Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentifiers.ContactsToContactDetailSegue.rawValue {
            guard let destinationViewController = segue.destinationViewController as? ContactDetailViewController,
                contacts = contacts,
                selectedIndexPath = selectedIndexPath
                else {
                return
            }
            destinationViewController.contact = contacts[selectedIndexPath.row]
            let backItem = UIBarButtonItem()
            backItem.title = NSLocalizedString("Back", comment: "Back")
            navigationItem.backBarButtonItem = backItem
        }
    }

}
