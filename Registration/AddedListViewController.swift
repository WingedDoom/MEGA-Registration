//
//  FirstViewController.swift
//  Registration
//
//  Created by Bulat Khabirov on 09.04.17.
//  Copyright © 2017 Bulat Khabirov. All rights reserved.
//

import UIKit
import RealmSwift

class AddedListViewController: UIViewController {

    let realm = try! Realm()
    @IBOutlet weak var tableView: UITableView!
    var registries: Results<RegistryModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registries = realm.objects(RegistryModel.self)
        configureTableView()
    }

    func configureTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        tableView.tableFooterView = UIView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "did_select_cell" {
            guard let cell = sender as? UITableViewCell,
                let indexPath = tableView.indexPath(for: cell) else { return }
            
            
            let navController = segue.destination as! UINavigationController
            let editController = navController.viewControllers.first! as! AddRegistryViewController
            editController.registry = registries[indexPath.row]
            editController.isEditingEntry = true
        }
    }
}

extension AddedListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = registries.count

        if count == 0 {
            let view = UIView()
            let label = UILabel()

            label.text = "Вы еще не добавили ни одной записи. Вы можете сделать это, нажав кнопку \"+\" в верхнем правом углу"
            label.textColor = .gray
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 0

            view.addSubview(label)
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[label]-16-|", metrics: nil, views: ["label": label]))
            view.addConstraint(NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0))

            tableView.backgroundView = view
        } else {
            tableView.backgroundView = nil
        }

        return count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! RegistryTableViewCell
        let model = registries[indexPath.row]
        
        cell.configure(with: RegistryCellViewConfig(model: model))
        
        return cell
    }

}

extension AddedListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
