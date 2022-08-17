//
//  TableViewController.swift
//  Contacts
//
//  Created by Vamsi Krishna on 15/07/22.
//

import UIKit
import Firebase

struct Section {
    let letter : String
    let names : [Contact]
}

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    var ref: DatabaseReference = Database.database().reference(withPath: "contacts")
    
    var contactsList = [Contact]();
    var sections = [Section]()
    var contacts = [ContactList]();

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.title = NSLocalizedString("ViewContactsTitle", comment: "View Contacts Title");
        self.searchBar.delegate = self;
        getContacts(filter: "");
        
    }
    
    /**
     Below method is used to update the table view with the data retrieved from firebase
     Sections are created based on first letter and the data are sorted and grouped into that sections
     */
    fileprivate func updateContactData() {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        let groupedDictionary = Dictionary(grouping: contactsList, by: {String($0.firstName.prefix(1))})
        let keys = groupedDictionary.keys.sorted()
        sections = keys.map{ Section(letter: $0, names: groupedDictionary[$0]!.sorted(by: {($0.lastName, $0.firstName) < ($1.lastName, $1.firstName)})) }
        contacts = keys.map{ ContactList(contacts: groupedDictionary[$0]!.sorted(by: {($0.lastName, $0.firstName) < ($1.lastName, $1.firstName)}))}
        self.tableView.reloadData()
    }
    
    /**
     Below method fetches the contact from firebase and update the contact list
     filter is passed as parameter to support search functionality
     */
    func getContacts(filter: String){
        ref.observe(.value, with: { snapshot in
            self.contactsList = [];
            for child in snapshot.children {
                if
                    let snapshot = child as? DataSnapshot {
                    let contact = Contact(contactId: Int64((snapshot.value! as AnyObject)["id"]!! as! String)!, firstName: (snapshot.value! as AnyObject)["firstName"]!! as! String, lastName: (snapshot.value! as AnyObject)["lastName"]!! as! String, phoneNumber: (snapshot.value! as AnyObject)["phoneNumber"]!! as! String);
                    self.contactsList.append(contact);
                }
            }
            if !filter.isEmpty {
                self.contactsList = self.contactsList.filter { (contacts) -> Bool in
                    ("\(contacts.firstName) \(contacts.lastName)").contains(filter)
                }
            }
            ContactApiModel.setContacts(contactList: self.contactsList);
            self.updateContactData();
        })
    }

    /**
     Below method defines the section count
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    /**
     Below method is to set the count of the rows in each section
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].names.count
    }

    /**
     Below method is used to updated the value for each cell with first name and last name
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "title"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as UITableViewCell
        let section = sections[indexPath.section]
        let contact = section.names[indexPath.row]
        cell.textLabel?.text = "\(contact.firstName) \(contact.lastName)"
        return cell
    }
    
    /**
     Below function is to set the title for the sections
     */
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sections.map{$0.letter}
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].letter.uppercased()
    }

    
    // MARK: - Navigation
    /**
     In a storyboard-based application, you will often want to do a little preparation before navigation
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the ContactViewController.
        if  segue.identifier == "showContactsSeque",
            let destination = segue.destination as? ContactViewController,
            let indexPath = tableView.indexPathForSelectedRow
        {
            let contact = contacts[indexPath.section].contacts;
            destination.sharedContact = contact[indexPath.row];
        }
    }
    
    /**
     This method helps to deselct row after processed so that when we select new row data is updated with new row on selection
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
    }
    
    /**
     Function to trigger on changes in the search bar
     */
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        getContacts(filter: searchText)
    }

}
