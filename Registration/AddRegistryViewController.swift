//
//  SecondViewController.swift
//  Registration
//
//  Created by Bulat Khabirov on 09.04.17.
//  Copyright © 2017 Bulat Khabirov. All rights reserved.
//

import UIKit

class AddRegistryViewController: UITableViewController {
    
    /// A boolean flag indicating whether the controller should create new registry or edit existing one
    var isEditingEntry = false
    
    /// Registry this controller is editing or about to create
    var registry: RegistryModel = RegistryModel()
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var midNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var companyTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        title = isEditingEntry ? "Редактирование" : "Добавление"
        
        if isEditingEntry {
            // set initial text fields' text
            
            
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

