//
//  contact.swift
//  Contacts
//
//  Created by Vamsi Krishna on 17/07/22.
//

import Foundation
import Firebase

/**
 Model Class to use contact details across the app
 */
class Contact {
    var contactId: Int64;
    var firstName: String;
    var lastName: String;
    var phoneNumber: String;
    
    init(contactId: Int64, firstName: String, lastName: String, phoneNumber: String) {
        self.contactId = contactId;
        self.firstName = firstName;
        self.lastName = lastName;
        self.phoneNumber = phoneNumber;
    }
}
