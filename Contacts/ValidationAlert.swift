//
//  ValidationAlert.swift
//  Contacts
//
//  Created by Vamsi Krishna on 17/08/22.
//

import Foundation
import UIKit

class ValidationAlert {
    
    /**
     Resusable function to validate the contacts on different pages
     */
    static func validateContact(firstName: UITextField, lastName: UITextField, phoneNumber: UITextField,
                         view: UIViewController) -> Bool {
        if(firstName.text == nil || firstName.text!.isEmpty){
            showAlert(message: "first name can't be empty", view: view)
            return false;
        }
        if(lastName.text == nil || lastName.text!.isEmpty){
            showAlert(message: "last name can't be empty", view: view)
            return false;
        }
        if(phoneNumber.text == nil || phoneNumber.text!.isEmpty){
            showAlert(message: "phone number can't be empty", view: view)
            return false;
        }
        if(firstName.text!.count > 15){
            showAlert(message: "first name can't have more than 15 characters", view: view)
            return false;
        }
        if(lastName.text!.count > 15){
            showAlert(message: "last name can't have more than 15 characters", view: view)
            return false;
        }
        if(phoneNumber.text!.count > 15){
            showAlert(message: "phone number can't have more than 15 numbers", view: view)
            return false;
        }
        return true;
    }
    
    /**
     Resuable show alert method to show the alert with custom message
     */
    static func showAlert(message: String, view: UIViewController){
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        view.present(alert, animated: true, completion: {})
    }
}
