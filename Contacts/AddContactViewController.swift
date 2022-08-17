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
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        contactFirstName.addTarget(nil, action:Selector(("firstResponderAction:")), for:.editingDidEndOnExit)
        contactLastName.addTarget(nil, action:Selector(("firstResponderAction:")), for:.editingDidEndOnExit)
        contactPhoneNumber.addTarget(nil, action:Selector(("firstResponderAction:")), for:.editingDidEndOnExit)
        
        contactFirstName.placeholder = NSLocalizedString("firstNamePlaceholder", comment: "place holder for first name")
        contactLastName.placeholder = NSLocalizedString("lastNamePlaceholder", comment: "place holder for last name")
        contactPhoneNumber.placeholder = NSLocalizedString("phoneNumberPlaceholder", comment: "place holder for phone number")
        self.title = NSLocalizedString("AddContactTitle", comment: "Add Contact Title");
    }
    
    @IBAction func cancelButtonClickListener(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true);
    }
    
    @IBAction func doneButtonCLickListener(_ sender: UIBarButtonItem) {
        
        let isValid = ValidationAlert.validateContact(firstName: contactFirstName, lastName: contactLastName, phoneNumber: contactPhoneNumber, view: self);
        
        if(!isValid){
            return;
        }
        
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
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

}
