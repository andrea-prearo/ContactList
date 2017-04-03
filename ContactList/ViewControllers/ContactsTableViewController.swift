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

    fileprivate var contacts: [Contact?]?
    fileprivate var filteredContacts: [Contact?]?
    fileprivate var contactViewModels: [ContactViewModel?] = []
    fileprivate var filteredContactViewModels: [ContactViewModel?] = []
    fileprivate var selectedIndexPath: IndexPath? = nil
    fileprivate let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

//        setUpStyle()
        setupSearchBar()

        Contact.getAll { [weak self] (success, contacts, error) -> () in
            guard let strongSelf = self else { return }
            if !success {
                DispatchQueue.main.async {
                    let title = NSLocalizedString("Error", comment: "Error")
                    if let error = error {
                        strongSelf.showError(title, message: error.localizedDescription)
                    } else {
                        strongSelf.showError(title, message: NSLocalizedString("Can't retrieve contacts.", comment: "Can't retrieve contacts."))
                    }
                }
            } else {
                strongSelf.contacts = contacts
                strongSelf.contactViewModels = strongSelf.cacheContacts(contacts)
                DispatchQueue.main.async {
                    strongSelf.tableView.reloadData()
                }
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

    func cacheContacts(_ contacts: [Contact?]?) -> [ContactViewModel?] {
        guard let contacts = contacts else { return [] }
        let contactViewModels: [ContactViewModel?] = contacts.map { contact in
            if let contact = contact {
                return ContactViewModel(contact: contact)
            } else {
                return nil
            }
        }
        return contactViewModels
    }
    
    func showDeleteContactAlert(_ contact: Contact) {
        let formatString = NSLocalizedString("Are you sure you want to delete %@?", comment: "Are you sure you want to delete this contact?")
        let contactName: String
        if let _ = contact.firstName,
            let _ = contact.lastName {
            contactName = contact.fullName
        } else {
            contactName = NSLocalizedString("this contact", comment: "this contact")
        }
        let message = String(format: formatString, contactName)
        let alert = UIAlertController(title: NSLocalizedString("Delete Contact", comment: "Delete Contact"),
            message: message,
            preferredStyle: .alert)
        
        let deleteActionString = NSLocalizedString("Delete", comment: "Delete")
        let deleteAction = UIAlertAction(title: deleteActionString, style: .destructive, handler: handleDeleteContact)
        let cancelActionString = NSLocalizedString("Cancel", comment: "Cancel")
        let cancelAction = UIAlertAction(title: cancelActionString, style: .cancel, handler: cancelDeleteContact)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleDeleteContact(_ alertAction: UIAlertAction!) -> Void {
        if let indexPath = selectedIndexPath,
            let contacts = contacts {
            tableView.beginUpdates()

            var row = (indexPath as NSIndexPath).row
            if let filteredContacts = filteredContacts
                , isSearchBarActive {
                self.filteredContacts = filteredContacts.dropAtIndex(row)
                filteredContactViewModels = cacheContacts(self.filteredContacts)
                row = contacts.index(where: { $0 == filteredContacts[row] }) ?? row
            }
            self.contacts = contacts.dropAtIndex(row)
            contactViewModels = cacheContacts(self.contacts)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            selectedIndexPath = nil
            
            tableView.endUpdates()
        }
    }
    
    func cancelDeleteContact(_ alertAction: UIAlertAction!) {
        selectedIndexPath = nil
    }

    func filterContacts(_ searchText: String, scope: String) {
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
            return searchController.isActive && searchController.searchBar.text?.isEmpty == false
        }
    }
}

// MARK: UITableViewDataSource protocol methods

extension ContactsTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactCellId, for: indexPath) as! ContactCell
        let contactViewModel: ContactViewModel?
        if isSearchBarActive {
            contactViewModel = filteredContactViewModels[(indexPath as NSIndexPath).row]
        } else {
            contactViewModel = contactViewModels[(indexPath as NSIndexPath).row]
        }
        
        if let viewModel = contactViewModel {
            cell.configure(viewModel)
        }
        return cell
    }
}


// MARK: UITableViewDelegate protocol methods

extension ContactsTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        performSegue(withIdentifier: SegueIdentifiers.ContactsToContactDetailSegue.rawValue, sender: self)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            selectedIndexPath = indexPath
            guard let contacts = contacts,
                let contact = contacts[(indexPath as NSIndexPath).row]
            else {
                return
            }
            showDeleteContactAlert(contact)
        }
    }
}

// MARK: Segues

extension ContactsTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.ContactsToContactDetailSegue.rawValue {
            guard let destinationViewController = segue.destination as? ContactDetailViewController else { return }
            guard let selectedIndexPath = selectedIndexPath else { return }

            let contact: Contact?
            if let filteredContacts = filteredContacts
                , isSearchBarActive {
                contact = filteredContacts[(selectedIndexPath as NSIndexPath).row]
            } else if let contacts = contacts {
                contact = contacts[(selectedIndexPath as NSIndexPath).row]
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
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContacts(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

// MARK: UISearchResultsUpdating Delegate

extension ContactsTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContacts(searchController.searchBar.text!, scope: scope)
    }
}
