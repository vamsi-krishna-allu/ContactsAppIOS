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
        // added selector that performs operation when keyboard is shown
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        // added selector that performs operation when keyboard is hidden
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // below lines closes keyboard when user clicks on done
        contactFirstName.addTarget(nil, action:Selector(("firstResponderAction:")), for:.editingDidEndOnExit)
        contactLastName.addTarget(nil, action:Selector(("firstResponderAction:")), for:.editingDidEndOnExit)
        contactPhoneNumber.addTarget(nil, action:Selector(("firstResponderAction:")), for:.editingDidEndOnExit)
        
        // below lines supports localization such thatit takes value based on language
        contactFirstName.placeholder = NSLocalizedString("firstNamePlaceholder", comment: "place holder for first name")
        contactLastName.placeholder = NSLocalizedString("lastNamePlaceholder", comment: "place holder for last name")
        contactPhoneNumber.placeholder = NSLocalizedString("phoneNumberPlaceholder", comment: "place holder for phone number")
        self.title = NSLocalizedString("AddContactTitle", comment: "Add Contact Title");
        
        // Added custom animation for the textfields
        CustomAnimation.animateTextField(textField: contactFirstName);
        CustomAnimation.animateTextField(textField: contactLastName);
        CustomAnimation.animateTextField(textField: contactPhoneNumber);
    }
    
    @IBAction func cancelButtonClickListener(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true);
    }
    
    /**
     On complete adding, data is saved and page is navigated back to view contacts screen with updated data
     */
    @IBAction func doneButtonCLickListener(_ sender: UIBarButtonItem) {
        // Verifies whether the entered data is vaid or not
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
    
    /**
     When keyboard is shown UI needs to scroll above such that textfields doesnot overlap with keyboard
     Using keybaord height to known the scroll amount required
     */
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    /**
     When keyboard is hidden UI needs to scroll back to original position
     */
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

}
