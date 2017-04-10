//
//  TimeCollectionViewCell.swift
//  Registration
//
//  Created by Bulat Khabirov on 10.04.17.
//  Copyright © 2017 Bulat Khabirov. All rights reserved.
//

import UIKit

class TimeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var registriesCountLabel: UILabel!
    
    var isEnabled = true {
        didSet {
            startTimeLabel.textColor = isEnabled ? .black : .lightGray
            endTimeLabel.textColor = isEnabled ? .black : .lightGray
            registriesCountLabel.textColor = isEnabled ? .gray : .red
            backgroundColor = isEnabled ? .white : UIColor.lightGray.withAlphaComponent(0.5)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            guard isEnabled else {
                if isSelected {
                    isSelected = false
                    isEnabled = false
                }
                return
            }
            backgroundColor = isSelected ? UIColor.green.withAlphaComponent(0.5) : .white
        }
    }
    
    func configure(with config: TimeCellViewConfig) {
        startTimeLabel.text = config.start
        endTimeLabel.text = config.end
        registriesCountLabel.text = config.count
        isEnabled = config.isEnabled
    }
}

struct TimeCellViewConfig {
    let start: String
    let end: String
    let count: String
    
    let isEnabled: Bool
    
    init(model: TimePeriod) {
        start = model.value.substring(to: model.value.index(model.value.startIndex, offsetBy: 5))
        end = model.value.substring(from: model.value.index(model.value.endIndex, offsetBy: -5))
        
        let registriesCount = DataService.shared.getNumberOfRegistries(for: model)
        isEnabled = registriesCount < 4
        count = "\(registriesCount)"
    }
}
