//
//  SecondViewController.swift
//  Registration
//
//  Created by Bulat Khabirov on 09.04.17.
//  Copyright © 2017 Bulat Khabirov. All rights reserved.
//

import UIKit
import RealmSwift

class AddRegistryViewController: UITableViewController {
    
    /// A boolean flag indicating whether the controller should create new registry or edit existing one
    var isEditingEntry = false
    
    /// Registry this controller is editing or about to create
    var registry: RegistryModel = RegistryModel()
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var companyTextField: UITextField!
    
    @IBOutlet weak var timeCollectionView: UICollectionView!

    var timePeriods: [TimePeriod]!
    var selectedPeriod: TimePeriod?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        timePeriods = DataService.shared.getSortedTimePeriods()
        configureView()
    }
    
    func configureView() {
        timeCollectionView.allowsSelection = true
        timeCollectionView.allowsMultipleSelection = false
        
        title = isEditingEntry ? "Редактирование" : "Добавление"
        
        if isEditingEntry {
            // set initial text fields' text
            nameTextField.text = registry.name
            lastNameTextField.text = registry.lastName
            phoneNumberTextField.text = registry.phoneNumber
            companyTextField.text = registry.company
            
            if timePeriods.index(of: registry.timePeriod) != nil {
                selectedPeriod = registry.timePeriod
            }
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        guard let period = selectedPeriod,
              nameTextField.text != nil,
              !nameTextField.text!.isEmpty,
              phoneNumberTextField.text != nil,
              !phoneNumberTextField.text!.isEmpty,
              lastNameTextField.text != nil,
              !lastNameTextField.text!.isEmpty,
              companyTextField.text != nil,
              !companyTextField.text!.isEmpty else {
                let alert = UIAlertController(title: "Действие невозможно", message: "Введены не все данные", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
        }
        
        let realm = try! Realm()
        try! realm.write {
            registry.name = nameTextField.text!
            registry.lastName = lastNameTextField.text!
            registry.phoneNumber = phoneNumberTextField.text!
            registry.company = companyTextField.text!
            registry.timePeriod = period
            
            if !realm.objects(RegistryModel.self).contains(registry) {
                realm.add(registry)
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension AddRegistryViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 70)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPeriod = timePeriods[indexPath.row]
        self.selectedPeriod = selectedPeriod
    }

}

extension AddRegistryViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timePeriods.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TimeCollectionViewCell
        let model = timePeriods[indexPath.row]
        
        cell.configure(with: TimeCellViewConfig(model: model))
        
        if let period = selectedPeriod, let index = timePeriods.index(of: period) {
            if index == indexPath.row {
                cell.isSelected = true
            }
        }
        
        return cell
    }
}
