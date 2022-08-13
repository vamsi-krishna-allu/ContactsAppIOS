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

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var ref: DatabaseReference = Database.database().reference(withPath: "contacts")
    
    var contactsList = [Contact]();
    var sections = [Section]()
    var contacts = [ContactList]();

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        getContacts();
    }
    
    fileprivate func updateContactData() {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        let groupedDictionary = Dictionary(grouping: contactsList, by: {String($0.firstName.prefix(1))})
        let keys = groupedDictionary.keys.sorted()
        sections = keys.map{ Section(letter: $0, names: groupedDictionary[$0]!.sorted(by: {($0.lastName, $0.firstName) < ($1.lastName, $1.firstName)})) }
        contacts = keys.map{ ContactList(contacts: groupedDictionary[$0]!.sorted(by: {($0.lastName, $0.firstName) < ($1.lastName, $1.firstName)}))}
        self.tableView.reloadData()
    }
    
    func getContacts(){
        ref.observe(.value, with: { snapshot in
            self.contactsList = [];
            for child in snapshot.children {
                if
                    let snapshot = child as? DataSnapshot {
                    let contact = Contact(contactId: Int64((snapshot.value! as AnyObject)["id"]!! as! String)!, firstName: (snapshot.value! as AnyObject)["firstName"]!! as! String, lastName: (snapshot.value! as AnyObject)["lastName"]!! as! String, phoneNumber: (snapshot.value! as AnyObject)["phoneNumber"]!! as! String);
                    self.contactsList.append(contact);
                }
            }
            ContactApiModel.setContacts(contactList: self.contactsList);
            self.updateContactData();
        })
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sections[section].names.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "title"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as UITableViewCell
        let section = sections[indexPath.section]
        let contact = section.names[indexPath.row]
        cell.textLabel?.text = "\(contact.firstName)  \(contact.lastName)"
        return cell
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sections.map{$0.letter}
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].letter
    }
    
    /**
        Below function is to enable the table for editable mode
        @param tableView, indexPath
    */
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true;
    }
    
    /**
        Setting the editingstyle format to delete to enable delete operation
        @param tableView, indexPath
    */
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete;
    }
    
    /**
        function is used to delete(as the editingstyle is delete) the specific row in the tableview
        and simulataneously delete from storage
        @param tableView, editingStyle, indexPath
    */
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates();
            contactsList.remove(at: indexPath.row);
            tableView.deleteRows(at: [indexPath], with: .fade);
            tableView.endUpdates();
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if  segue.identifier == "showContactsSeque",
            let destination = segue.destination as? ContactViewController,
            let indexPath = tableView.indexPathForSelectedRow
        {
            let contact = contacts[indexPath.section].contacts;
            destination.sharedContact = contact[indexPath.row];
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
    }

}
