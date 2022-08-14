//
//  ContactViewController.swift
//  Contacts
//
//  Created by Vamsi Krishna on 17/07/22.
//

import UIKit

class ContactViewController: UIViewController {

    @IBOutlet var firstName: UITextField!
    @IBOutlet var lastName: UITextField!
    @IBOutlet var phoneNumber: UITextField!
    
    var sharedContact: Contact = Contact(contactId: -1, firstName: "",lastName: "",phoneNumber: "");
    
    override func viewWillAppear(_ animated: Bool) {
        firstName.text = sharedContact.firstName;
        lastName.text = sharedContact.lastName;
        phoneNumber.text = sharedContact.phoneNumber;
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "editContactSeque",
            let destination = segue.destination as? EditContactViewController
        {
            destination.sharedContact = sharedContact;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
