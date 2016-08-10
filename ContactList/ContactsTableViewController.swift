//
//  ContactsTableViewController.swift
//  ContactList
//
//  Created by Andrea Prearo on 3/6/16.
//  Copyright © 2016 Andrea Prearo
//

import UIKit

let ContactCellId = "ContactCell"

class ContactsTableViewController: UITableViewController {
    
    static let scopeButtonTitleDefault = NSLocalizedString("Default", comment: "Default")
    static let scopeButtonTitleFirstName = NSLocalizedString("First Name", comment: "First Name")
    static let scopeButtonTitleLastName = NSLocalizedString("Last Name", comment: "Last Name")
    static let scopeButtonTitleCompany = NSLocalizedString("Company", comment: "Company")

    private var contacts: [Contact?]?
    private var filteredContacts: [Contact?]?
    private var contactViewModels: [ContactViewModel?] = []
    private var filteredContactViewModels: [ContactViewModel?] = []
    private var selectedIndexPath: NSIndexPath? = nil
    private let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpStyle()
        setupSearchBar()

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
                guard let strongSelf = self else { return }
                strongSelf.contacts = contacts
                strongSelf.contactViewModels = strongSelf.cacheContacts(contacts)
                strongSelf.tableView.reloadData()
            }
        }
    }

}

// MARK: Private Methods and Computed Properties

private extension ContactsTableViewController {

    func setUpStyle() {
        tableView.backgroundColor = UIColor.defaultBackgroundColor()
    }

    func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.scopeButtonTitles = [
            ContactsTableViewController.scopeButtonTitleDefault,
            ContactsTableViewController.scopeButtonTitleFirstName,
            ContactsTableViewController.scopeButtonTitleLastName,
            ContactsTableViewController.scopeButtonTitleCompany]
        tableView.tableHeaderView = searchController.searchBar
    }

    func cacheContacts(contacts: [Contact?]?) -> [ContactViewModel?] {
        guard let contacts = contacts else { return [] }
        let contactViewModels:[ContactViewModel?] = contacts.map { contact in
            if let contact = contact {
                return ContactViewModel(contact: contact)
            } else {
                return nil
            }
        }
        return contactViewModels
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
        
        let deleteActionString = NSLocalizedString("Delete", comment: "Delete")
        let deleteAction = UIAlertAction(title: deleteActionString, style: .Destructive, handler: handleDeleteContact)
        let cancelActionString = NSLocalizedString("Cancel", comment: "Cancel")
        let cancelAction = UIAlertAction(title: cancelActionString, style: .Cancel, handler: cancelDeleteContact)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func handleDeleteContact(alertAction: UIAlertAction!) -> Void {
        if let indexPath = selectedIndexPath,
            contacts = contacts {
            tableView.beginUpdates()

            var row = indexPath.row
            if let filteredContacts = filteredContacts
                where isSearchBarActive {
                self.filteredContacts = filteredContacts.dropAtIndex(row)
                filteredContactViewModels = cacheContacts(self.filteredContacts)
                row = contacts.indexOf({ $0 == filteredContacts[row] }) ?? row
            }
            self.contacts = contacts.dropAtIndex(row)
            contactViewModels = cacheContacts(self.contacts)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            selectedIndexPath = nil
            
            tableView.endUpdates()
        }
    }
    
    func cancelDeleteContact(alertAction: UIAlertAction!) {
        selectedIndexPath = nil
    }

    func filterContacts(searchText: String, scope: String) {
        filteredContacts = contacts?.filter({ contact -> Bool in
            guard let contact = contact else { return false }
            if scope == ContactsTableViewController.scopeButtonTitleDefault {
                return String.caseInsensitiveContains(contact.fullName, searchText: searchText)
            } else if scope == ContactsTableViewController.scopeButtonTitleFirstName {
                return String.caseInsensitiveContains(contact.firstName, searchText: searchText)
            } else if scope == ContactsTableViewController.scopeButtonTitleLastName {
                return String.caseInsensitiveContains(contact.lastName, searchText: searchText)
            } else if scope == ContactsTableViewController.scopeButtonTitleCompany {
                return String.caseInsensitiveContains(contact.company, searchText: searchText)
            }
            return false
        })
        filteredContactViewModels = cacheContacts(filteredContacts)
        tableView.reloadData()
    }

    var isSearchBarActive: Bool {
        get {
            return searchController.active && searchController.searchBar.text?.isEmpty == false
        }
    }

}

// MARK: UITableViewDataSource protocol methods

extension ContactsTableViewController {

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchBarActive {
            if let filteredContacts = filteredContacts {
                return filteredContacts.count
            } else {
                return 0
            }
        }
        if let contacts = contacts {
            return contacts.count
        } else {
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ContactCellId, forIndexPath: indexPath) as! ContactCell
        let contactViewModel: ContactViewModel?
        if isSearchBarActive {
            contactViewModel = filteredContactViewModels[indexPath.row]
        } else {
            contactViewModel = contactViewModels[indexPath.row]
        }
        
        if let viewModel = contactViewModel {
            cell.configure(viewModel)
        }
        return cell
    }

}


// MARK: UITableViewDelegate protocol methods

extension ContactsTableViewController {
    
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

}

// MARK: Segues

extension ContactsTableViewController {

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentifiers.ContactsToContactDetailSegue.rawValue {
            guard let destinationViewController = segue.destinationViewController as? ContactDetailViewController else { return }
            guard let selectedIndexPath = selectedIndexPath else { return }

            let contact: Contact?
            if let filteredContacts = filteredContacts
                where isSearchBarActive {
                contact = filteredContacts[selectedIndexPath.row]
            } else if let contacts = contacts {
                contact = contacts[selectedIndexPath.row]
            } else {
                return
            }

            destinationViewController.contact = contact
            let backItem = UIBarButtonItem()
            backItem.title = NSLocalizedString("Back", comment: "Back")
            navigationItem.backBarButtonItem = backItem
        }
    }

}

// MARK: UISearchBarDelegate Delegate

extension ContactsTableViewController: UISearchBarDelegate {

    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContacts(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }

}

// MARK: UISearchResultsUpdating Delegate

extension ContactsTableViewController: UISearchResultsUpdating {

    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContacts(searchController.searchBar.text!, scope: scope)
    }

}
