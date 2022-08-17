//
//  EditContactViewController.swift
//  Contacts
//
//  Created by Vamsi Krishna on 17/07/22.
//

import UIKit
import Firebase

class EditContactViewController: UIViewController {
    
    @IBOutlet var firstName: UITextField!
    @IBOutlet var lastName: UITextField!
    @IBOutlet var phoneNumber: UITextField!
    
    @IBOutlet var contactTitle: UILabel!
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var doneButton: UIBarButtonItem!
    
    @IBOutlet var deleteButton: UIButton!
    
    var sharedContact: Contact = Contact(contactId: 0, firstName: "",lastName: "",phoneNumber: "");
    var ref: DatabaseReference = Database.database().reference(withPath: "contacts")

    /**
     This method is fired when ever view appears either during back navigation or while loading first time
     */
    override func viewWillAppear(_ animated: Bool) {
        firstName.text = sharedContact.firstName;
        lastName.text = sharedContact.lastName;
        phoneNumber.text = sharedContact.phoneNumber;
    }
    

    override func viewDidLoad() {
        super.viewDidLoad();
        
        // added selector that performs operation when keyboard is shown
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        // added selector that performs operation when keyboard is hidden
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // below lines closes keyboard when user clicks on done
        firstName.addTarget(nil, action:Selector(("firstResponderAction:")), for:.editingDidEndOnExit)
        lastName.addTarget(nil, action:Selector(("firstResponderAction:")), for:.editingDidEndOnExit)
        phoneNumber.addTarget(nil, action:Selector(("firstResponderAction:")), for:.editingDidEndOnExit)
        
        // Added a rounded contact title which is the first  letter of user name
        contactTitle.layer.cornerRadius = 75
        contactTitle.textAlignment = NSTextAlignment.center
        contactTitle.layer.backgroundColor = UIColor.darkGray.cgColor
        contactTitle.text = sharedContact.firstName.prefix(1).uppercased()
        
        deleteButton.setTitle(NSLocalizedString("DeleteButton", comment: "Delete Contact"), for: .normal)
        
        // Added custom animation for the textfields, labels and button
        CustomAnimation.animateTextField(textField: firstName);
        CustomAnimation.animateTextField(textField: lastName);
        CustomAnimation.animateTextField(textField: phoneNumber);
        CustomAnimation.animateLabels(label: contactTitle);
        CustomAnimation.animateButton(button: deleteButton);
    }
    /**
     Action sheet is shown when user clicks on cancel to reverify if user wants to discard the changes done
     */
    @IBAction func cancelButtonClickListener(_ sender: UIBarButtonItem) {
        showActionSheet(message: NSLocalizedString("AreYouSure", comment: "Are you sure you want to discard your changes"), destructiveTitle:  NSLocalizedString("discardChanges", comment: "discard changes")
, cancelTitle:  NSLocalizedString("keepEditing", comment: "keep editing")
, destructiveAction: discardChanges);
    }
    
    func discardChanges() -> Void {
        self.navigationController?.popViewController(animated: true);
    }
    
    /**
     On complete editing data is saved and page is navigated back to view contacts screen with updated data
     */
    @IBAction func doneButtonCLickListener(_ sender: UIBarButtonItem) {
        // Verifies whether the entered data is vaid or not
        let isValid = ValidationAlert.validateContact(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, view: self);
        
        if(!isValid){
            return;
        }
        
        sharedContact.firstName = firstName.text!;
        sharedContact.lastName = lastName.text!;
        sharedContact.phoneNumber = phoneNumber.text!;
        
        
        let contactDictionary: [String: String] = ["id": String(sharedContact.contactId),
                                 "firstName": sharedContact.firstName,
                                 "lastName":sharedContact.lastName,
                                 "phoneNumber":sharedContact.phoneNumber]
        let contactRef = self.ref.child(String(sharedContact.contactId))
        contactRef.setValue(contactDictionary)
        
        self.navigationController?.popViewController(animated: true);

    }
    
    /**
     When delete contact is triggered action sheet has to be shown for reconfirmation
     */
    @IBAction func onDeleteContact(_ sender: UIButton) {
        showActionSheet(message: "",destructiveTitle: NSLocalizedString("DeleteButton", comment: "Delete Contact"), cancelTitle: NSLocalizedString("cancel", comment: "Cancel"), destructiveAction: deleteContact);
    }
    
    /**
     Deletes the contact from firebase
     */
    func deleteContact() -> Void {
        let contactRef = self.ref.child(String(sharedContact.contactId));
        contactRef.removeValue()
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true);
    }
    
    /**
     Need to show action sheet to get confirmation from user for some of the actions
     Such as Delte contact requires action sheet to get the user confirmation again
     */
    func showActionSheet(message: String, destructiveTitle: String, cancelTitle: String, destructiveAction:@escaping () -> Void) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: destructiveTitle, style: .destructive , handler:{ (UIAlertAction)in
            destructiveAction();
        }))
        
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel , handler:{_ in }))

        self.present(alert, animated: true, completion: {})
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
