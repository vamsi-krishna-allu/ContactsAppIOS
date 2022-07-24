//
//  EditContactViewController.swift
//  Contacts
//
//  Created by Vamsi Krishna on 17/07/22.
//

import UIKit

class EditContactViewController: UIViewController {
    
    @IBOutlet var firstName: UITextField!
    @IBOutlet var lastName: UITextField!
    @IBOutlet var phoneNumber: UITextField!
    
    var sharedContact: contact = contact(firstName: "",lastName: "",phoneNumber: "");
    
    override func viewWillAppear(_ animated: Bool) {
        firstName.text = sharedContact.firstName;
        lastName.text = sharedContact.lastName;
        phoneNumber.text = sharedContact.phoneNumber;
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
