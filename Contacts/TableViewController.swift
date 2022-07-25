//
//  TableViewController.swift
//  Contacts
//
//  Created by Vamsi Krishna on 15/07/22.
//

import UIKit

struct Section {
    let letter : String
    let names : [contact]
}

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var contactsList = [contact]();
    var sections = [Section]()
    

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        getContacts();
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        let groupedDictionary = Dictionary(grouping: contactsList, by: {String($0.firstName.prefix(1))})
        let keys = groupedDictionary.keys.sorted()
        sections = keys.map{ Section(letter: $0, names: groupedDictionary[$0]!.sorted(by: {($0.lastName, $0.firstName) < ($1.lastName, $1.firstName)})) }
        self.tableView.reloadData()
    }
    
    func getContacts(){
        
        contactsList.append(
            contact(firstName: "A", lastName: "Kenndy", phoneNumber: "123456789"));
        contactsList.append(
            contact(firstName: "AdJohn", lastName: "Kenndy", phoneNumber: "123456789"));
        contactsList.append(
            contact(firstName: "AdJohn", lastName: "AKenndy", phoneNumber: "123456789"));
        contactsList.append(
            contact(firstName: "BeJohn", lastName: "Kenndy", phoneNumber: "123456789"));
        contactsList.append(
            contact(firstName: "BaJohn", lastName: "Kenndy", phoneNumber: "123456789"));
        contactsList.append(
            contact(firstName: "BbJohn", lastName: "Kenndy", phoneNumber: "123456789"));
        contactsList.append(
            contact(firstName: "CfJohn", lastName: "Kenndy", phoneNumber: "123456789"));
        contactsList.append(
            contact(firstName: "DaJohn", lastName: "Kenndy", phoneNumber: "123456789"));
        contactsList.append(
            contact(firstName: "EgJohn", lastName: "Kenndy", phoneNumber: "123456789"));
        contactsList.append(
            contact(firstName: "WjJohn", lastName: "Kenndy", phoneNumber: "123456789"));
        contactsList.append(
            contact(firstName: "EiJohn", lastName: "Kenndy", phoneNumber: "123456789"));
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if  segue.identifier == "showContactsSeque",
            let destination = segue.destination as? ContactViewController,
            let contactIndex = tableView.indexPathForSelectedRow?.row
        {
            destination.sharedContact = contactsList[contactIndex];
        }
    }
    

}
