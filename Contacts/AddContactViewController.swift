//
//  AddContactViewController.swift
//  Contacts
//
//  Created by Vamsi Krishna on 24/07/22.
//

import UIKit

class AddContactViewController: UIViewController {

    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelButtonClickListener(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true);
    }
    
    @IBAction func doneButtonCLickListener(_ sender: UIBarButtonItem) {
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
