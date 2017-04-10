//
//  RegistryModel.swift
//  Registration
//
//  Created by Bulat Khabirov on 09.04.17.
//  Copyright © 2017 Bulat Khabirov. All rights reserved.
//

import UIKit
import RealmSwift

class RegistryModel: Object {
    var name = ""
    var midName = ""
    var lastName = ""
    
    var company = ""
    
    var timePeriod: TimePeriod! = TimePeriod()
}
