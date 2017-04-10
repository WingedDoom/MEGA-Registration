//
//  RegistryTableViewCell.swift
//  Registration
//
//  Created by Bulat Khabirov on 10.04.17.
//  Copyright © 2017 Bulat Khabirov. All rights reserved.
//

import UIKit

class RegistryTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    func configure(with config: RegistryCellViewConfig) {
        nameLabel.text = config.name
        timeLabel.text = config.timePeriod
        companyLabel.text = config.company
    }
}

struct RegistryCellViewConfig {
    let name: String
    let company: String
    let timePeriod: String
    
    init(model: RegistryModel) {
        name = model.lastName + " " + model.name + " " + model.midName
        company = model.company
        timePeriod = model.timePeriod.value
    }
}
