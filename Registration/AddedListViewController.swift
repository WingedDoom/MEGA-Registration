//
//  FirstViewController.swift
//  Registration
//
//  Created by Bulat Khabirov on 09.04.17.
//  Copyright © 2017 Bulat Khabirov. All rights reserved.
//

import UIKit
import RealmSwift
import MessageUI

class AddedListViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var counterItem: UIBarButtonItem!
    let realm = try! Realm()
    @IBOutlet weak var tableView: UITableView!
    var registries: Results<RegistryModel>!
    var sortedRegistries: [RegistryModel]!
    
    var token: NotificationToken!
    var addedCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registries = realm.objects(RegistryModel.self)
        sortedRegistries = registries.sorted { $0.timePeriod < $1.timePeriod }
        configureTableView()
        
        counterItem.title = "Всего: \(sortedRegistries.count)"
        token = registries.addNotificationBlock({ [weak self] (_) in
            self?.tableView.reloadData()
            self?.sortedRegistries = self!.registries.sorted { $0.timePeriod < $1.timePeriod }
            self?.counterItem.title = "Всего: \(self!.sortedRegistries.count)"
            self?.addedCount += 1
            
            if self!.addedCount % 5 == 0 {
                let mailController = MFMailComposeViewController()
                
                mailController.setSubject("Новая версия списка данных о зарегистрированых пользователях")
                mailController.setToRecipients(["aliya@immotion.me"])
                mailController.setMessageBody("Отправлено через приложение Registration.", isHTML: false)
                mailController.addAttachmentData(DataService.shared.exportCacheInXLS(), mimeType: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", fileName: "Очередь.xlsx")
                mailController.mailComposeDelegate = self
                self?.present(mailController, animated: true, completion: nil)
            }
        })
    }
    
    deinit {
        token.stop()
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
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
            editController.registry = sortedRegistries[indexPath.row]
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
        let model = sortedRegistries[indexPath.row]
        
        cell.configure(with: RegistryCellViewConfig(model: model))
        
        return cell
    }

}

extension AddedListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
