//
//  AddContactViewController.swift
//  Contacts
//
//  Created by Vamsi Krishna on 24/07/22.
//

import UIKit
import Firebase

class AddContactViewController: UIViewController {

    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var doneButton: UIBarButtonItem!
    
    @IBOutlet var contactLastName: UITextField!
    @IBOutlet var contactFirstName: UITextField!
    @IBOutlet var contactPhoneNumber: UITextField!
    
    var sharedContact: Contact = Contact(contactId: -1, firstName: "",lastName: "",phoneNumber: "");
    var ref: DatabaseReference = Database.database().reference(withPath: "contacts")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelButtonClickListener(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true);
    }
    
    @IBAction func doneButtonCLickListener(_ sender: UIBarButtonItem) {
        let id = (ContactApiModel.getContacts().last?.contactId ?? 0) + 1;
        sharedContact = Contact(contactId: id, firstName: (contactFirstName != nil ? contactFirstName.text! : "") , lastName: (contactLastName != nil ? contactLastName.text! : ""), phoneNumber:
                                (contactPhoneNumber != nil ? contactPhoneNumber.text! : ""))
        let contactDictionary: [String: String] = ["id": String(id),
                                 "firstName": sharedContact.firstName,
                                 "lastName":sharedContact.lastName,
                                 "phoneNumber":sharedContact.phoneNumber]
        let contactRef = self.ref.child(String(id))
        
        contactRef.setValue(contactDictionary)

        self.navigationController?.popViewController(animated: true);
    }

}
