//
//  ContactApiModel.swift
//  Contacts
//
//  Created by Vamsi Krishna on 27/07/22.
//

import Foundation
import FirebaseDatabase

class ContactApiModel{
    
    static private var contactList: [Contact] = [];
    
    static func getContacts() -> [Contact] {
        return contactList;
    }

    static func setContacts(contactList: [Contact]) {
        self.contactList = contactList;
    }
}
