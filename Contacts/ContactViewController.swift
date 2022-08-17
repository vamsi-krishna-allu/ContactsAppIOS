//
//  ContactViewController.swift
//  Contacts
//
//  Created by Vamsi Krishna on 17/07/22.
//

import UIKit

class ContactViewController: UIViewController {

    
    @IBOutlet var phoneNumber: UILabel!
    @IBOutlet var contactName: UILabel!
    @IBOutlet var contactTitle: UILabel!
    
    var sharedContact: Contact = Contact(contactId: -1, firstName: "",lastName: "",phoneNumber: "");
    
    /**
     This method is fired when ever view appears either during back navigation or while loading first time
     */
    override func viewWillAppear(_ animated: Bool) {
        contactName.text = "\(sharedContact.firstName) \(sharedContact.lastName)";
        phoneNumber.text = sharedContact.phoneNumber;
    }
    
    /**
     In a storyboard-based application, you will often want to do a little preparation before navigation
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Here it navigates to EditContactViewController based on seque
        if  segue.identifier == "editContactSeque",
            let destination = segue.destination as? EditContactViewController
        {
            destination.sharedContact = sharedContact;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactTitle.layer.cornerRadius = 75
        contactTitle.textAlignment = NSTextAlignment.center
        contactTitle.layer.backgroundColor = UIColor.darkGray.cgColor
        contactTitle.text = sharedContact.firstName.prefix(1).uppercased()
        
        // setting custom animations to the labels on the page
        CustomAnimation.animateLabels(label: contactTitle);
        CustomAnimation.animateLabels(label: phoneNumber);
        CustomAnimation.animateLabels(label: contactName);
    }

}
